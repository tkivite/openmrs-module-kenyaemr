<%
	ui.decorateWith("kenyaemr", "standardPage", [ layout: "sidebar" ])
%>

<style type="text/css">
#calendar .ui-widget-content {
	border: 0;
	background: inherit;
	padding: 0;
}
</style>

<div class="ke-page-sidebar">
	${ ui.includeFragment("kenyaui", "widget/panelMenu", [
		heading: "Tasks",
		items: [
			[ iconProvider: "kenyaui", icon: "buttons/patient_search.png", label: "Search for a Patient", href: ui.pageLink("kenyaemr", "registration/registrationSearch") ]
		]
	]) }

	${ ui.decorate("kenyaui", "panel", [ heading: "Select Day to View" ], """<div id="calendar"></div>""") }

	<div class="ke-panel-frame" id="end-of-day">
		<div class="ke-panel-heading">End of Day</div>

		<div class="ke-panel-content">
			Close all open visits of the following types:
			<form id="close-visits-form" method="post" action="${ ui.actionLink("kenyaemr", "registrationUtil", "closeActiveVisits") }">
				<div class="form-data"></div>
				<input type="submit" value="Close Visits" />
				<div class="ke-form-globalerrors" style="display: none"></div>
			</form>
		</div>
	</div>
</div>

<div class="ke-page-content">
	${ ui.includeFragment("kenyaemr", "dailySchedule", [ id: "schedule", page: "registration/registrationViewPatient", date: scheduleDate ]) }
</div>

<script type="text/javascript">
	jq(function() {
		jq('#calendar').datepicker({
			dateFormat: 'yy-mm-dd',
			defaultDate: '${ new java.text.SimpleDateFormat("yyyy-MM-dd").format(scheduleDate) }',
			gotoCurrent: true,
			onSelect: function(dateText) {
				location.href = ui.pageLink('kenyaemr', 'registration/registrationHome', { scheduleDate: dateText });
			}
		});

		kenyaui.setupAjaxPost('close-visits-form', {
			onSuccess: function (result) {
				loadActiveVisitTypes();
				ui.notifySuccess(result.message);
			}
		});

		loadActiveVisitTypes();
	});

	function loadActiveVisitTypes() {
		jq.getJSON(ui.fragmentActionLink('kenyaemr', 'registrationUtil', 'activeVisitTypes'), function(result) {
			if (result.length == 0) {
				jq('#end-of-day').hide();
				return;
			}
			else {
				var str = "";
				for (var i = 0; i < result.length; ++i) {
					var r = result[i];
					str += '<div class="spaced"><input type="checkbox" name="visitType" value="' + r.visitTypeId + '"/> ' + r.name + ' (' + r.count + ')</div>';
				}
				jq('#end-of-day .form-data').html(str);
				jq('#end-of-day').show();
			}
		});
	}
</script>