*** Settings ***
Force Tags      pybot  jybot  regression
Resource        rebot_cli_resource.robot
Suite Setup     Create empty input file
Suite Teardown  Remove file    ${EMPTY INPUT}

*** Test Cases ***

No tests in file
     Rebot empty suite    --processemptysuite    ${EMPTY INPUT}

Empty suite after filtering by tags
     Rebot empty suite    --ProcessEmptySuite --include nonex    ${MY INPUT}

Empty suite after filtering by names
     Rebot empty suite    --ProcessEmpty --test nonex    ${MY INPUT}

Empty multi source suite after filtering
     Rebot empty suite    --ProcessE --test nonex    ${MY INPUT}    ${MY INPUT}

Empty input is fine with other inputs by default
     Run rebot    ${EMPTY}    ${EMPTY INPUT}    ${MY INPUT}
     Should be empty    ${SUITE.suites[0].tests}
     Should not be empty    ${SUITE.suites[1].tests}
     Stderr should be empty


*** Keywords ***

Create empty input file
     Run Tests Without Processing Output    --include nonex --RunEmptySuite    ${TEST FILE}
     Set Suite Variable    ${EMPTY INPUT}    ${MY OUTDIR}/empty_input.xml
     Move File    ${OUTFILE}    ${EMPTY INPUT}

Rebot empty suite
     [Arguments]    ${options}    @{sources}
     Run rebot     ${options} -l log.html -r report.html    @{sources}
     Should be empty  ${SUITE.tests}
     Should be empty  ${SUITE.suites}
     Stderr should be empty
