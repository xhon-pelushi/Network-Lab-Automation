#!/usr/bin/env python3
"""
Network Topology Scanner
Discovers network topology and generates documentation
"""

import ipaddress
import subprocess
import json
from datetime import datetime
from typing import List, Dict

class NetworkScanner:
    def __init__(self, network: str):
        self.network = ipaddress.ip_network(network, strict=False)
        self.hosts = []
        
    def ping_host(self, ip: str) -> bool:
        """Test if host is reachable"""
        try:
            result = subprocess.run(
                ['ping', '-n', '1', '-w', '1000', str(ip)],
                capture_output=True,
                timeout=2
            )
            return result.returncode == 0
        except:
            return False
    
    def scan_network(self) -> List[Dict]:
        """Scan network for active hosts"""
        print(f"Scanning network: {self.network}")
        print(f"Total addresses: {self.network.num_addresses}")
        
        active_hosts = []
        
        for ip in self.network.hosts():
            print(f"Scanning {ip}...", end='\r')
            if self.ping_host(ip):
                host_info = {
                    'ip': str(ip),
                    'status': 'active',
                    'timestamp': datetime.now().isoformat()
                }
                active_hosts.append(host_info)
                print(f"Found active host: {ip}")
        
        self.hosts = active_hosts
        return active_hosts
    
    def generate_report(self, output_file: str = 'topology-report.json'):
        """Generate topology report"""
        report = {
            'network': str(self.network),
            'scan_date': datetime.now().isoformat(),
            'total_hosts': len(self.hosts),
            'active_hosts': self.hosts,
            'topology': {
                'subnets': [
                    {
                        'network': str(self.network),
                        'hosts': len(self.hosts),
                        'gateway': str(self.network.network_address + 1)
                    }
                ]
            }
        }
        
        with open(output_file, 'w') as f:
            json.dump(report, f, indent=2)
        
        print(f"\nReport generated: {output_file}")
        return report

def main():
    # Scan common lab networks
    networks = [
        '192.168.10.0/24',
        '192.168.20.0/24',
        '192.168.30.0/24'
    ]
    
    all_results = []
    
    for network in networks:
        scanner = NetworkScanner(network)
        hosts = scanner.scan_network()
        report = scanner.generate_report(f'topology-{network.replace("/", "-")}.json')
        all_results.extend(hosts)
    
    # Generate combined report
    combined_report = {
        'scan_date': datetime.now().isoformat(),
        'total_active_hosts': len(all_results),
        'hosts': all_results
    }
    
    with open('combined-topology-report.json', 'w') as f:
        json.dump(combined_report, f, indent=2)
    
    print(f"\nTotal active hosts found: {len(all_results)}")

if __name__ == '__main__':
    main()


















































