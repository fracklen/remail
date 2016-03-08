@CampaignRuns = React.createClass
  getInitialState: ->
    campaign_runs: @props.data

  getDefaultState: ->
    campaign_runs: []
    url: '/users/campaigns'

  deleteCampaignRun: (campaign_run) ->
    index = @state.campaign_runs.indexOf campaign_run
    campaign_runs = React.addons.update(@state.campaign_runs, { $splice: [[index, 1]] })
    @replaceState campaign_runs: campaign_runs

  componentDidMount: ->
    @interval = setInterval(@updateCampaignRuns, 10000)

  updateCampaignRuns: ->
    $.ajax
      url: @props.url
      dataType: 'json'
      cache: false
      success: (data) =>
        @setState(campaign_runs: data)

      error: (xhr, status, err) =>
        console.error(@props.url, status, err.toString())

  render: ->
    React.DOM.div
      className: 'campaign-runs'
      React.DOM.h2
        className: 'title'
        'Campaign Runs'
      React.DOM.table
        className: 'table table-bordered campaign_runs'
        React.DOM.thead null,
          React.DOM.tr null,
            React.DOM.th null, 'Run id'
            React.DOM.th null, 'State'
            React.DOM.th null, 'Processed'
            React.DOM.th null, 'Sent to'
            React.DOM.th null, 'Rejected'
            React.DOM.th null, 'Recipients'
            React.DOM.th null, 'Progress'
            React.DOM.th null, 'Success'
            React.DOM.th null, 'Actions'
        React.DOM.tbody null,
          for campaign_run in @state.campaign_runs
            React.createElement CampaignRun, key: campaign_run.id, campaign_run: campaign_run, handleDeleteCampaignRun: @deleteCampaignRun

