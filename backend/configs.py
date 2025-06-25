from dataclasses import dataclass, field
from email.policy import default
from enum import StrEnum


class ActivityStatus(StrEnum):
    utilization ="Utilization"
    malfunction = "Malfunction"
    idle = "Idle"
    charging = "Charging"
    signal_absent = "Signal absent"
    invalid = "Invalid"


@dataclass
class HistoricalData:
    period_in_days: int #
    activity_status: dict[ActivityStatus, float]  # for example ActivityStatus.Auslasting = 0.20

@dataclass
class Vehicle:
    id: str
    previous_data: HistoricalData
    last_soh: float

@dataclass
class Fleet:
    fleet_id: str
    vehicles : list[Vehicle]
    previous_data: HistoricalData
    last_soh: float

@dataclass
class RollingStock:
    fleet_overview : list[Fleet]


class Overview:
    fleet_per_category: dict[str, RollingStock]