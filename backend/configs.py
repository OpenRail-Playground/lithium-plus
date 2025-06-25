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

class VehicleStatus(StrEnum):
    available = "Available"
    error_status = "Error Status"
    no_connection = "No Connection"

@dataclass
class CurrentStatus:
    state_of_health: float = 0.8 # average over vehicles that are available
    availability : dict[str, int] = field(default_factory=dict) # per vehicle the state: green ( no error message, message received), red (error message) , grey no connection
    percentage_of_available_vehicles: float = 0.0

@dataclass
class HistoricalData:
    period_in_days: int #
    activity_status: dict[ActivityStatus, float]  # for example ActivityStatus.Auslasting = 0.20


@dataclass
class Fleet:
    fleet_id: str
    vehicle_ids : list[str]
    previous_data: HistoricalData
    current_state: CurrentStatus

@dataclass
class RollingStock:
    fleet_overview : list[Fleet]


class Overview:
    fleet_per_category: dict[str, RollingStock]