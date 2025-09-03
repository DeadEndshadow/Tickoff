**TickOff Akzeptanzkriterien**

**Akzeptanzkriterien zu den User Stories**


**User Story: Zeckenfunde melden**

UC1-1: Der Nutzer kann eine Zeckenmeldung nur mit aktiviertem Standort senden.

UC1-2: Eine Meldung enthält Standort, Zeitstempel und Anzahl der Zecken.

UC1-3: Die Meldung wird innerhalb von 30 Sekunden in der Datenbank gespeichert und auf der Karte angezeigt.

UC1-4: Der gesamte Meldeprozess ist so intuitiv, dass 80 % der Testnutzer (inklusive Senioren) ihn in unter einer Minute abschliessen können.

UC1-5: Meldungen, die offline erfasst wurden, werden automatisch bei der nächsten Internetverbindung hochgeladen.


**User Story: Risikogebiete auf der Karte sehen**

UC2-1: Die App zeigt Hotspots farblich an (grün, orange, rot).

UC2-2: Die Kartenansicht wird auf einem durchschnittlichen Smartphone in unter 3 Sekunden geladen.

UC2-3: Die zuletzt geladene Kartenansicht bleibt auch bei fehlender Internetverbindung sichtbar.


**User Story: Push-Benachrichtigungen erhalten**

UC3-1: Nutzer erhalten Push-Benachrichtigungen, wenn sie einen vordefinierten Hotspot-Radius betreten.

UC3-2: Die Standortdaten des Nutzers werden ausschliesslich für diese Funktion verwendet und nicht dauerhaft gespeichert.


**User Story: App in bevorzugter Sprache nutzen**

UC4-1: Alle Texte und UI-Elemente sind in Deutsch, Englisch und Französisch verfügbar.

UC4-2: Die Sprache kann jederzeit im Einstellungsmenü ohne Neustart der App gewechselt werden.


**User Story: Erste-Hilfe-Informationen finden**

UC5-1: Die Info-Seite enthält bebilderte Erste-Hilfe-Anleitungen für Zeckenbisse.

UC5-2: Die Info-Seite bietet zusätzlich Präventionstipps und Infos zu Krankheiten wie FSME und Borreliose.

UC5-3: Alle Informationen sind in der gewählten Sprache verfügbar.


**User Story: Quellcode wartbar machen**

UC6-1: Der Quellcode ist modular strukturiert, um die zukünftige Integration weiterer Features zu ermöglichen.

UC6-2: Die App verwendet eine API-Struktur, die eine einfache Erweiterung der Funktionalitäten erlaubt.


**User Story: Monitoring-Dashboard**

UC7-1: Ein Dashboard (z.B. über Firebase Analytics) erfasst die Anzahl monatlich aktiver Nutzer und Meldungen pro Region.

UC7-2: Das Dashboard zeigt die Aufrufrate der Erste-Hilfe-Seite.


**User Story: Offline-Fähigkeit**

UC8-1: Offline-Meldungen werden temporär auf dem Gerät gespeichert.

UC8-2: Bei bestehender Internetverbindung werden die gespeicherten Meldungen automatisch an die Datenbank gesendet.


**User Story: Barrierefreiheit**

UC9-1: Die Schriftgrösse passt sich den Systemeinstellungen des Nutzers an oder ist skalierbar.

UC9-2: Die App entspricht den WCAG-Standards bezüglich Farbkontrast und Lesbarkeit.

UC9-3: Buttons und Icons entsprechen den UI-Richtlinien von Apple und Google.
