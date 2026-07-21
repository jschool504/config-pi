---
title: "ClinRecsFhirPatientHandler filter logic"
tags: [event-handler,patient-handler,filter-logic,demographics,entity-change]
created: 2026-07-20
hits: 0
---
ClinRecsFhirPatientHandler (shared/Services/EventHandlers/PatientHandlers/ClinRecsFhirPatientHandler.cs) fires on PatientTrigger for Added and Modified states.

Filter rules:
- Requires all three demographic categories on NewPerson: name (GivenName/Surname/LegalName), gender (LegalSex/BiologicalSex/Gender), DOB (BirthDate)
- For Modified: only fires if at least one whitelisted field changed between ExistingPerson and NewPerson (GivenName, Surname, LegalName, LegalSex, BiologicalSex, Gender, BirthDate)
- Non-demographic changes (Email, Phone, Address) are skipped
- Added state fires only when all categories are populated at creation time
- Handled via helper methods: HasAllDemographics(Person), DidDemographicsChange(existing, new)
