@CampaignRun = React.createClass
  progress_pct: ->
    (100.0 * ((@props.campaign_run.processed) / @props.campaign_run.total_recipients)).toFixed(1)

  success_rate: ->
    if @props.campaign_run.processed < 1
      0
    else
      (100.0 * @props.campaign_run.sent / @props.campaign_run.processed).toFixed(1)

  showDelete: ->
    @props.campaign_run.state in ['FINISHED', 'STOPPED', 'CANCELLED', 'ERROR']

  handleDelete: (e) ->
    e.preventDefault()
    $.ajax
      method: 'DELETE'
      url: "/users/campaigns/#{ @props.campaign_run.campaign_id }/campaign_runs/#{ @props.campaign_run.id }"
      dataType: 'JSON'
      success: () =>
        @props.handleDeleteCampaignRun @props.campaign_run

  showCancel: ->
    @props.campaign_run.state == 'STARTED' ||
      @props.campaign_run.state == 'PENDING'

  handleCancel: (e) ->
    e.preventDefault()
    $.ajax
      method: 'POST'
      url: "/users/campaigns/#{ @props.campaign_run.campaign_id }/campaign_runs/#{ @props.campaign_run.id }/cancel"
      dataType: 'JSON'
      success: () =>
        @props.campaign_run.state = 'CANCELLING'

  showStop: ->
    @props.campaign_run.state == 'STARTED' ||
      @props.campaign_run.state == 'PENDING'

  handleStop: (e) ->
    e.preventDefault()
    $.ajax
      method: 'POST'
      url: "/users/campaigns/#{ @props.campaign_run.campaign_id }/campaign_runs/#{ @props.campaign_run.id }/stop"
      dataType: 'JSON'
      success: () =>
        @props.campaign_run.state = 'STOPPING'

  render: ->
    React.DOM.tr null,
      React.DOM.td null, @props.campaign_run.id
      React.DOM.td null, @props.campaign_run.state
      React.DOM.td null, @props.campaign_run.processed
      React.DOM.td null, @props.campaign_run.sent
      React.DOM.td null, @props.campaign_run.rejected
      React.DOM.td null, @props.campaign_run.total_recipients
      React.DOM.td null,
        React.DOM.progress
          max: 100
          value: "#{@progress_pct()}"

      React.DOM.td null,
        React.DOM.progress
          max: 100
          value: "#{@success_rate()}"
      React.DOM.td null,
        @showDelete() && React.DOM.a
          className: 'btn btn-danger'
          onClick: @handleDelete
          'Delete'
        @showCancel() && React.DOM.a
          className: 'btn btn-warning'
          onClick: @handleCancel
          'Cancel'
        @showStop() && React.DOM.a
          className: 'btn btn-warning'
          onClick: @handleStop
          'Stop'

