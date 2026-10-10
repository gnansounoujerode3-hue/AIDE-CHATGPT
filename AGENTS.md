# Instructions for video and audio tasks

- Read and follow `.agents/skills/ffmpeg-skill/SKILL.md` for the FFmpeg workflow and tool usage.
- Treat `Brief_Agent_IA_Montage_Video_Marketing_Automatique.pdf` as the project-specific authority for editorial choices, privacy, and delivery. If it differs from the generic skill, follow the PDF.
- Process media locally by default, keep original files unchanged, and never upload private rushes to a cloud service without explicit authorization.
- Do not invent dialogue, subtitles, claims, prices, offers, music, logos, or calls to action. Use subtitles only when the transcript is supplied or can be verified.
- If the platform is unspecified, preserve a suitable source aspect ratio and export MP4 with H.264 video and AAC audio.
- This skill does not bundle FFmpeg executables. Run `scripts/setup_video_tools.sh` once, then invoke skill commands through `scripts/video-tools.sh` so the project-local binaries are on `PATH`. `.video-tools/` is generated and ignored; do not commit its binaries.
- Use the skill's `doctor` check for capability gaps, and never bypass TLS verification to fetch a binary.
- Verify each real export with `ffprobe` (or an equivalent), decode-check it, and inspect representative frames before claiming it is complete.
