#!/usr/bin/env python3

"""将“μ可畏-鼠标指针.zip”转换为本地多尺寸 Xcursor 主题。"""

from __future__ import annotations

import argparse
from collections.abc import Iterator
import os
from pathlib import Path
import shutil
import struct
import subprocess
import tempfile
import zipfile


IMAGE_TYPE = 0xFFFD0002
IMAGE_VERSION = 1
DEFAULT_SIZES = (24, 32, 36, 48, 64, 72, 96, 128)

# 只转换 Windows 安装清单实际启用的版本；带数字的文件是手动替换版本。
CURSOR_SOURCES = {
    "default": "正常选择.ani",
    "help": "帮助选择.ani",
    "progress": "后台运行.ani",
    "wait": "忙.ani",
    "crosshair": "精确选择.ani",
    "text": "文本选择.ani",
    "pencil": "手写.ani",
    "not-allowed": "不可用.ani",
    "ns-resize": "垂直调整大小.ani",
    "ew-resize": "水平调整大小.ani",
    "nwse-resize": "沿对角线调整大小 1.ani",
    "nesw-resize": "沿对角线调整大小 2.ani",
    "all-resize": "移动.ani",
    "up_arrow": "候选.ani",
    "pointer": "链接选择.ani",
    "pin": "位置选择.ani",
    "person": "个人选择.ani",
}

# 覆盖 GTK、Qt/KDE、CSS、X11 cursor font 与常见拖放名称。
ALIASES = {
    "00000000000000020006000e7e9ffc3f": "progress",
    "00008160000006810000408080010102": "ns-resize",
    "03b6e0fcb3499374a867c041f52298f0": "not-allowed",
    "08e8e1c95fe2fc01f976f1e063a24ccd": "progress",
    "1081e37283d90000800003c07f3ef6bf": "pointer",
    "3085a0e285430894940527032f8b26df": "pointer",
    "3ecb610c1bf2410f44200f48c40d3599": "progress",
    "4498f0e0c1937ffe01fd06f973665830": "all-resize",
    "5c6cd98b3f3ebcb1f9c7f1c204630408": "help",
    "6407b0e94181790501fd1e167b474872": "pointer",
    "640fb0e74195791501fd1ed57b41487f": "pointer",
    "9081237383d90e509aa00f00170e968f": "all-resize",
    "9d800788f1b08800ae810202380a0822": "pointer",
    "a2a266d0498c3104214a47bd64ab0fc8": "pointer",
    "b66166c04f8c3109214a4fbd64a50fc8": "pointer",
    "d9ce0ab605698f320427677b458ad60b": "help",
    "e29285e634086352946a0e7090d73106": "pointer",
    "fcf21c00b30f7e3f83fe0dfd12e71cff": "all-resize",
    "alias": "pointer",
    "all-scroll": "all-resize",
    "alternate": "up_arrow",
    "arrow": "default",
    "bd_double_arrow": "nwse-resize",
    "bottom_left_corner": "nesw-resize",
    "bottom_right_corner": "nwse-resize",
    "bottom_side": "ns-resize",
    "cell": "crosshair",
    "center_ptr": "up_arrow",
    "circle": "not-allowed",
    "closedhand": "all-resize",
    "col-resize": "ew-resize",
    "copy": "pointer",
    "cross": "crosshair",
    "cross_reverse": "crosshair",
    "crossed_circle": "not-allowed",
    "dgn1": "nwse-resize",
    "dgn2": "nesw-resize",
    "diamond_cross": "crosshair",
    "dnd-copy": "pointer",
    "dnd-move": "all-resize",
    "dnd-none": "not-allowed",
    "e-resize": "ew-resize",
    "fd_double_arrow": "nesw-resize",
    "fleur": "all-resize",
    "forbidden": "not-allowed",
    "grab": "all-resize",
    "grabbing": "all-resize",
    "h_double_arrow": "ew-resize",
    "half-busy": "progress",
    "hand": "pointer",
    "hand1": "pointer",
    "hand2": "pointer",
    "handwriting": "pencil",
    "horz": "ew-resize",
    "ibeam": "text",
    "left_ptr": "default",
    "left_ptr_help": "help",
    "left_ptr_watch": "progress",
    "left_side": "ew-resize",
    "link": "pointer",
    "location": "pin",
    "move": "all-resize",
    "n-resize": "ns-resize",
    "ne-resize": "nesw-resize",
    "no-drop": "not-allowed",
    "ns-resize-cursor": "ns-resize",
    "nw-resize": "nwse-resize",
    "openhand": "all-resize",
    "plus": "crosshair",
    "pointing_hand": "pointer",
    "question_arrow": "help",
    "right_side": "ew-resize",
    "row-resize": "ns-resize",
    "s-resize": "ns-resize",
    "sb_h_double_arrow": "ew-resize",
    "sb_v_double_arrow": "ns-resize",
    "se-resize": "nwse-resize",
    "size-bdiag": "nesw-resize",
    "size-fdiag": "nwse-resize",
    "size-hor": "ew-resize",
    "size-ver": "ns-resize",
    "size_all": "all-resize",
    "size_bdiag": "nesw-resize",
    "size_fdiag": "nwse-resize",
    "size_hor": "ew-resize",
    "size_ver": "ns-resize",
    "sw-resize": "nesw-resize",
    "tcross": "crosshair",
    "top_left_arrow": "default",
    "top_left_corner": "nwse-resize",
    "top_right_corner": "nesw-resize",
    "top_side": "ns-resize",
    "up-arrow": "up_arrow",
    "user": "person",
    "v_double_arrow": "ns-resize",
    "vert": "ns-resize",
    "w-resize": "ew-resize",
    "watch": "wait",
    "whats_this": "help",
    "xterm": "text",
}

INDEX_THEME = """[Icon Theme]
Name=μ可畏 Pointer
Comment=原作者：bilibili 一葉A4；本地转换为多尺寸 Xcursor 主题
Inherits=breeze_cursors,Adwaita
"""

SOURCE_NOTICE = """μ可畏鼠标指针来源说明

原作者：哔哩哔哩 一葉A4
作者主页：https://space.bilibili.com/36254981

原始压缩包声明本套鼠标指针免费分享，同时禁止商用与二次传播。
本目录由本地转换脚本生成，仅供个人使用，不应提交到公开仓库。
"""


def iter_chunks(
    data: bytes, start: int = 12, end: int | None = None
) -> Iterator[tuple[bytes, bytes]]:
    """遍历 RIFF 容器中的直接子块。"""
    if end is None:
        end = len(data)
    position = start
    while position + 8 <= end:
        chunk_id = data[position : position + 4]
        size = struct.unpack_from("<I", data, position + 4)[0]
        payload_start = position + 8
        payload_end = payload_start + size
        if payload_end > end:
            raise ValueError("RIFF 子块越界")
        yield chunk_id, data[payload_start:payload_end]
        position = payload_end + (size & 1)


def parse_ani(data: bytes) -> tuple[list[bytes], list[int], list[int]]:
    """读取 ANI 帧、播放顺序与 1/60 秒单位的帧时长。"""
    if data[:4] != b"RIFF" or data[8:12] != b"ACON":
        raise ValueError("输入文件不是 RIFF ACON 动画指针")

    header: tuple[int, ...] | None = None
    frames: list[bytes] = []
    rates: list[int] = []
    sequence: list[int] = []
    for chunk_id, payload in iter_chunks(data):
        if chunk_id == b"anih":
            if len(payload) < 36:
                raise ValueError("ANI anih 块长度无效")
            header = struct.unpack_from("<9I", payload)
        elif chunk_id == b"rate":
            rates = list(struct.unpack(f"<{len(payload) // 4}I", payload))
        elif chunk_id == b"seq ":
            sequence = list(struct.unpack(f"<{len(payload) // 4}I", payload))
        elif chunk_id == b"LIST" and payload[:4] == b"fram":
            frames.extend(
                sub_payload
                for sub_id, sub_payload in iter_chunks(payload, 4)
                if sub_id == b"icon"
            )

    if header is None or not frames:
        raise ValueError("ANI 缺少 anih 或 icon 帧")
    frame_count = header[1]
    step_count = header[2] or frame_count
    default_rate = header[7] or 6
    if frame_count != len(frames):
        raise ValueError(f"ANI 声明 {frame_count} 帧，实际读取 {len(frames)} 帧")
    if not sequence:
        sequence = list(range(step_count))
    if not rates:
        rates = [default_rate] * step_count
    if len(sequence) != step_count or len(rates) != step_count:
        raise ValueError("ANI 播放顺序或帧时长数量与步数不一致")
    if any(index >= len(frames) for index in sequence):
        raise ValueError("ANI 播放顺序引用了不存在的帧")
    return frames, sequence, rates


def cur_metadata(data: bytes) -> tuple[int, int, int, int]:
    """读取单图像 CUR 的尺寸与热点。"""
    if len(data) < 22:
        raise ValueError("CUR 文件过短")
    reserved, image_type, count = struct.unpack_from("<HHH", data)
    if reserved != 0 or image_type != 2 or count < 1:
        raise ValueError("ANI 帧不是有效的 Windows CUR")
    width, height, _, _, hot_x, hot_y, _, _ = struct.unpack_from(
        "<BBBBHHII", data, 6
    )
    return width or 256, height or 256, hot_x, hot_y


def decode_cur(data: bytes, temporary_file: Path) -> tuple[int, int, int, int, bytes]:
    """借助 ImageMagick 解码 CUR，返回未缩放 RGBA 像素。"""
    width, height, hot_x, hot_y = cur_metadata(data)
    temporary_file.write_bytes(data)
    result = subprocess.run(
        [
            "magick",
            str(temporary_file),
            "-alpha",
            "on",
            "-depth",
            "8",
            "rgba:-",
        ],
        check=True,
        stdout=subprocess.PIPE,
    )
    expected_size = width * height * 4
    if len(result.stdout) != expected_size:
        raise ValueError(
            f"ImageMagick 返回 {len(result.stdout)} 字节，预期 {expected_size} 字节"
        )
    return width, height, hot_x, hot_y, result.stdout


def scale_rgba_nearest(
    rgba: bytes, source_width: int, source_height: int, target_size: int
) -> bytes:
    """使用保留首尾像素的最近邻缩放，并转换为 Xcursor ARGB。"""
    output = bytearray(target_size * target_size * 4)
    output_offset = 0
    for target_y in range(target_size):
        source_y = scale_coordinate(
            target_y,
            target_size,
            source_height,
        )
        for target_x in range(target_size):
            source_x = scale_coordinate(
                target_x,
                target_size,
                source_width,
            )
            source_offset = (source_y * source_width + source_x) * 4
            red, green, blue, alpha = rgba[source_offset : source_offset + 4]
            if alpha == 0:
                argb = 0
            else:
                red = (red * alpha + 127) // 255
                green = (green * alpha + 127) // 255
                blue = (blue * alpha + 127) // 255
                argb = (alpha << 24) | (red << 16) | (green << 8) | blue
            struct.pack_into("<I", output, output_offset, argb)
            output_offset += 4
    return bytes(output)


def scale_coordinate(value: int, from_extent: int, to_extent: int) -> int:
    """将坐标映射到目标范围，并确保两个端点都不会被跳过。"""
    if from_extent <= 1 or to_extent <= 1:
        return 0
    numerator = value * (to_extent - 1)
    denominator = from_extent - 1
    return (numerator * 2 + denominator) // (denominator * 2)


def scale_hotspot(value: int, source_size: int, target_size: int) -> int:
    """使用与像素相同的端点映射缩放热点。"""
    return scale_coordinate(value, source_size, target_size)


def make_image_chunk(
    size: int, hot_x: int, hot_y: int, delay: int, pixels: bytes
) -> bytes:
    """创建单个 Xcursor image chunk。"""
    header = struct.pack(
        "<9I",
        36,
        IMAGE_TYPE,
        size,
        IMAGE_VERSION,
        size,
        size,
        hot_x,
        hot_y,
        delay,
    )
    return header + pixels


def write_xcursor(path: Path, chunks: list[tuple[int, bytes]]) -> None:
    """写入 Xcursor 文件头、TOC 与 image chunks。"""
    toc_size = len(chunks) * 12
    position = 16 + toc_size
    toc_entries: list[bytes] = []
    image_chunks: list[bytes] = []
    for subtype, chunk in chunks:
        toc_entries.append(struct.pack("<3I", IMAGE_TYPE, subtype, position))
        image_chunks.append(chunk)
        position += len(chunk)

    with path.open("wb") as output:
        output.write(struct.pack("<4I", 0x72756358, 16, 0x00010000, len(chunks)))
        output.writelines(toc_entries)
        output.writelines(image_chunks)


def build_cursor(
    ani_data: bytes, output: Path, sizes: tuple[int, ...], temporary_cur: Path
) -> None:
    """将一个 ANI 角色转换为包含全部尺寸的 Xcursor。"""
    frames, sequence, rates = parse_ani(ani_data)
    decoded_frames = [decode_cur(frame, temporary_cur) for frame in frames]
    chunks: list[tuple[int, bytes]] = []
    for size in sizes:
        for step, frame_index in enumerate(sequence):
            width, height, hot_x, hot_y, rgba = decoded_frames[frame_index]
            if width != height:
                raise ValueError("当前转换器只支持方形 ANI 帧")
            delay = max(1, (rates[step] * 1000 + 30) // 60)
            pixels = scale_rgba_nearest(rgba, width, height, size)
            chunks.append(
                (
                    size,
                    make_image_chunk(
                        size,
                        scale_hotspot(hot_x, width, size),
                        scale_hotspot(hot_y, height, size),
                        delay,
                        pixels,
                    ),
                )
            )
    write_xcursor(output, chunks)


def prepare_output(output: Path, force: bool) -> None:
    """检查输出位置，防止 --force 删除过宽的目录。"""
    resolved = output.resolve()
    protected = {Path("/").resolve(), Path.home().resolve(), Path.cwd().resolve()}
    if resolved in protected or len(resolved.parts) < 4:
        raise ValueError(f"拒绝使用危险输出路径：{resolved}")
    if output.exists() or output.is_symlink():
        if not force:
            raise FileExistsError(f"输出已存在；确认重建时请添加 --force：{output}")
        if output.is_symlink() or output.is_file():
            output.unlink()
        else:
            shutil.rmtree(output)


def build_theme(
    archive: Path, output: Path, sizes: tuple[int, ...], force: bool
) -> None:
    """构建主题并在成功后原子移动到最终目录。"""
    if shutil.which("magick") is None:
        raise RuntimeError("未找到 ImageMagick 的 magick 命令")
    prepare_output(output, force)
    output.parent.mkdir(parents=True, exist_ok=True)

    with zipfile.ZipFile(archive) as source_zip:
        available = set(source_zip.namelist())
        missing = sorted(set(CURSOR_SOURCES.values()) - available)
        if missing:
            raise ValueError(f"压缩包缺少 ANI 文件：{', '.join(missing)}")

        with tempfile.TemporaryDirectory(
            prefix=f".{output.name}.build-", dir=output.parent
        ) as temporary_root:
            temporary_root_path = Path(temporary_root)
            theme_root = temporary_root_path / output.name
            cursors_dir = theme_root / "cursors"
            cursors_dir.mkdir(parents=True)
            temporary_cur = temporary_root_path / "frame.cur"

            for cursor_name, source_name in CURSOR_SOURCES.items():
                print(f"转换 {source_name} -> {cursor_name}")
                build_cursor(
                    source_zip.read(source_name),
                    cursors_dir / cursor_name,
                    sizes,
                    temporary_cur,
                )

            for alias, target in sorted(ALIASES.items()):
                alias_path = cursors_dir / alias
                if alias_path.exists() or alias_path.is_symlink():
                    continue
                alias_path.symlink_to(target)

            (theme_root / "index.theme").write_text(INDEX_THEME, encoding="utf-8")
            (theme_root / "SOURCE-NOTICE.txt").write_text(
                SOURCE_NOTICE, encoding="utf-8"
            )
            os.replace(theme_root, output)

    print(f"已生成主题：{output}")
    print(f"包含尺寸：{', '.join(map(str, sizes))}")


def parse_arguments() -> argparse.Namespace:
    """解析命令行参数。"""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("archive", type=Path, help="原始 μ可畏鼠标指针 ZIP")
    parser.add_argument("output", type=Path, help="生成的 Xcursor 主题目录")
    parser.add_argument(
        "--sizes",
        type=int,
        nargs="+",
        default=DEFAULT_SIZES,
        help="生成尺寸，默认：24 32 36 48 64 72 96 128",
    )
    parser.add_argument(
        "--force", action="store_true", help="确认删除并重建已存在的输出目录"
    )
    return parser.parse_args()


def main() -> None:
    """程序入口。"""
    arguments = parse_arguments()
    archive = arguments.archive.expanduser().resolve()
    output = arguments.output.expanduser().absolute()
    sizes = tuple(sorted(set(arguments.sizes)))
    if not archive.is_file():
        raise FileNotFoundError(f"找不到压缩包：{archive}")
    if not sizes or any(size < 8 or size > 512 for size in sizes):
        raise ValueError("尺寸必须位于 8 到 512 之间")
    build_theme(archive, output, sizes, arguments.force)


if __name__ == "__main__":
    main()
