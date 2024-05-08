<#macro surveyFormFields>
    <div class="${properties.kcFormGroupClass!}">
        <div class="${properties.kcLabelWrapperClass!}">
            <label for="zipCode" class="${properties.kcLabelClass!}">ZIP code or pilot site</label>
        </div>
        <div class="${properties.kcInputWrapperClass!}">
            <input type="text" id="zipCode" class="${properties.kcInputClass!}" name="user.attributes.zipCode" required="required"/>
        </div>
    </div>

    <div class="${properties.kcFormGroupClass!}">
        <div class="${properties.kcLabelWrapperClass!}">
            <label for="organizationType" class="${properties.kcLabelClass!}">Type of organization you represent</label>
        </div>
        <div class="${properties.kcInputWrapperClass!}">
            <select id="organizationType" class="${properties.kcInputClass!}" name="user.attributes.organizationType" required="required">
                <option value="citizen">Citizen</option>
                <option value="public_servant">Public servant</option>
                <option value="non_profit_organization">Non-profit organization</option>
                <option value="for_profit_organization">For-profit organization</option>
            </select>
        </div>
    </div>

    <div class="${properties.kcFormGroupClass!}">
        <div class="${properties.kcLabelWrapperClass!}">
            <label for="disadvantagedGroup" class="${properties.kcLabelClass!}">Do you belong to a disadvantaged group: ethnic, gender, economic, social, or other?</label>
        </div>
        <div class="${properties.kcInputWrapperClass!}">
            <select id="disadvantagedGroup" class="${properties.kcInputClass!}" name="user.attributes.disadvantagedGroup" required="required">
                <option value="yes">Yes</option>
                <option value="no">No</option>
                <option value="prefer_not_to_say">I do not want to answer</option>
            </select>
        </div>
    </div>

    <div class="${properties.kcFormGroupClass!}">
        <div class="${properties.kcLabelWrapperClass!}">
            <label for="ageRange" class="${properties.kcLabelClass!}">Age range</label>
        </div>
        <div class="${properties.kcInputWrapperClass!}">
            <select id="ageRange" class="${properties.kcInputClass!}" name="user.attributes.ageRange" required="required">
                <option value="18_and_under">18 and under</option>
                <option value="19_24">19 - 24</option>
                <option value="25_31">25 - 31</option>
                <option value="32_38">32 - 38</option>
                <option value="39_49">39 - 49</option>
                <option value="50_59">50 - 59</option>
                <option value="60_and_over">60 and over</option>
            </select>
        </div>
    </div>

    <div class="${properties.kcFormGroupClass!}">
        <div class="${properties.kcLabelWrapperClass!}">
            <label for="gender" class="${properties.kcLabelClass!}">Gender</label>
        </div>
        <div class="${properties.kcInputWrapperClass!}">
            <select id="gender" class="${properties.kcInputClass!}" name="user.attributes.gender" required="required">
                <option value="male">Male</option>
                <option value="female">Female</option>
                <option value="non_binary">Non-binary</option>
                <option value="prefer_not_to_say">I do not want to answer</option>
            </select>
        </div>
    </div>

    <div class="${properties.kcFormGroupClass!}">
        <div class="${properties.kcLabelWrapperClass!}">
            <label for="educationLevel" class="${properties.kcLabelClass!}">Level of education</label>
        </div>
        <div class="${properties.kcInputWrapperClass!}">
            <select id="educationLevel" class="${properties.kcInputClass!}" name="user.attributes.educationLevel" required="required">
                <option value="secondary_school">Secondary school</option>
                <option value="high_school_diploma">High school diploma</option>
                <option value="vocational_training">Vocational training</option>
                <option value="bachelor_degree">Bachelor degree</option>
                <option value="master_degree">Master’s degree</option>
                <option value="phd">PhD</option>
            </select>
        </div>
    </div>

    <div class="${properties.kcFormGroupClass!}">
        <div class="${properties.kcLabelWrapperClass!}">
            <label for="digitalToolsAcquaintance" class="${properties.kcLabelClass!}">Digital tools’ acquaintance</label>
        </div>
        <div class="${properties.kcInputWrapperClass!}">
            <select id="digitalToolsAcquaintance" class="${properties.kcInputClass!}" name="user.attributes.digitalToolsAcquaintance" required="required">
                <option value="zero">Zero level (I do not use any digital tool including a smartphone)</option>
                <option value="basic">Basic level (I use WhatsApp, I browse a little through websites, ...)</option>
                <option value="intermediate">Intermediate level (I browse websites, I watch videos on YouTube, ...)</option>
                <option value="advanced">Advanced level (I make purchases electronically, I use spreadsheets, ...)</option>
            </select>
        </div>
    </div>

    <div class="${properties.kcFormGroupClass!}">
        <div class="${properties.kcLabelWrapperClass!}">
            <label for="workStatus" class="${properties.kcLabelClass!}">Work status</label>
        </div>
        <div class="${properties.kcInputWrapperClass!}">
            <select id="workStatus" class="${properties.kcInputClass!}" name="user.attributes.workStatus" required="required">
                <option value="unemployed">Unemployed</option>
                <option value="self_employed">Self-employed</option>
                <option value="employed_private">Employed (private sector)</option>
                <option value="employed_public">Employed (public sector)</option>
                <option value="retired">Retired</option>
                <option value="student">Student</option>
                <option value="other">Other (please specify)</option>
            </select>
        </div>
    </div>

    <div class="${properties.kcFormGroupClass!}">
        <div class="${properties.kcLabelWrapperClass!}">
            <label for="thematicRole" class="${properties.kcLabelClass!}">Role played in thematic co-explorations</label>
        </div>
        <div class="${properties.kcInputWrapperClass!}">
            <select id="thematicRole" class="${properties.kcInputClass!}" name="user.attributes.thematicRole" required="required" multiple>
                <option value="participant">Participant – active participant in a thematic co-exploration team</option>
                <option value="core_team_member">Core team member- organizer and knowledge leader of a thematic co-exploration</option>
                <option value="pilot_owner">Pilot owner - promoter of a thematic co-exploration in a domain</option>
                <option value="citizenry">Citizenry - target for dissemination and communication of results of a thematic co-exploration</option>
                <option value="stakeholder">Stakeholder - sponsor and receiver of results of a thematic co-exploration</option>
            </select>
        </div>
    </div>

</#macro>