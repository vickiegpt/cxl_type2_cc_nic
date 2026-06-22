import subprocess
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]

PLAN_AND_SPEC_PREFIXES = (
    "docs/superpowers/plans/",
    "docs/superpowers/specs/",
)

BLOCKED_TERMS = (
    "IA-780I",
    "IA780I",
    "IA_780I",
    "IA-780",
    "ia780i",
    "ia-780i",
    "BittWare",
    "tokio1",
    "ConnectX",
    "PM1733a",
    "ens4063",
    "ens4043",
    "fpgans",
    "cx7test",
    "0000:8a:00.0",
    "0000:15:00.0",
    "/root/cxl_type2_nic",
    "/mnt/pm1733a",
    "vickiegpt/cxl_type2_nic",
    "cxl_type2_nic",
)

BLOCKED_PATH_PARTS = (
    "__pycache__",
    ".pytest_cache",
    "ia780i",
    "ia-780i",
    "bmc",
    "oot_driver",
    "nic_to_nvme",
)

BLOCKED_SUFFIXES = (
    ".cmd",
    ".ko",
    ".mod",
    ".o",
    ".pyc",
    ".bin",
    ".pdf",
)

TEXT_SUFFIXES = (
    "",
    ".c",
    ".h",
    ".md",
    ".py",
    ".sh",
    ".sv",
    ".tcl",
    ".v",
    ".vhd",
    ".vh",
    ".yml",
    ".yaml",
    ".json",
    ".gitignore",
    ".qip",
    ".ip",
    ".mk",
)


def repo_files() -> list[str]:
    output = subprocess.check_output(
        ["git", "ls-files", "-z", "--cached", "--others", "--exclude-standard"],
        cwd=REPO_ROOT,
    )
    files = [entry.decode("utf-8") for entry in output.split(b"\0") if entry]
    return [path for path in files if (REPO_ROOT / path).is_file()]


def is_plan_or_spec(path: str) -> bool:
    return path.startswith(PLAN_AND_SPEC_PREFIXES)


def is_hygiene_test(path: str) -> bool:
    return path == "tests/test_generic_repo.py"


def is_text_like(path: str) -> bool:
    suffix = Path(path).suffix
    return suffix in TEXT_SUFFIXES


def test_no_blocked_legacy_terms_in_generic_files() -> None:
    matches: list[str] = []
    for path in repo_files():
        if is_plan_or_spec(path) or is_hygiene_test(path) or not is_text_like(path):
            continue
        text = (REPO_ROOT / path).read_text(encoding="utf-8", errors="ignore")
        for term in BLOCKED_TERMS:
            if term in text:
                matches.append(f"{path}: {term}")

    assert not matches, "blocked legacy terms found:\n" + "\n".join(matches[:80])


def test_no_generated_or_vendor_artifacts_tracked() -> None:
    bad_paths: list[str] = []
    for path in repo_files():
        lowered = path.lower()
        if is_plan_or_spec(path):
            continue
        if any(part in lowered for part in BLOCKED_PATH_PARTS):
            bad_paths.append(path)
            continue
        if path.endswith(BLOCKED_SUFFIXES):
            bad_paths.append(path)

    assert not bad_paths, "blocked generated/vendor artifacts tracked:\n" + "\n".join(bad_paths[:80])
