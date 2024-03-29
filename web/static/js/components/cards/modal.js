import React, {PropTypes} from 'react';
import ReactGravatar      from 'react-gravatar';
import PageClick          from 'react-page-click';
import moment             from 'moment';
import { push }           from 'react-router-redux';

import Actions            from '../../actions/current_card';
import BoardActions       from '../../actions/current_board';
import MembersSelector    from './members_selector';
import TagsSelector       from './tags_selector';
import TypeSelector       from './type_selector';

export default class CardModal extends React.Component {
  componentDidUpdate() {
    const { edit } = this.props;

    if (edit) this.refs.name.focus();
  }

  _closeModal(e) {
    e.preventDefault();

    const { dispatch, boardId } = this.props;

    dispatch(push(`/boards/${boardId}`));
  }

  _renderCommentForm() {
    const { currentUser } = this.props;

    return (
      <div className="form-wrapper">
        <form onSubmit={::this._handleCommentFormSubmit}>
          <header>
            <h4>Add comment</h4>
          </header>
          <div className="gravatar-wrapper">
            <ReactGravatar className="react-gravatar" email={currentUser.email} https />
          </div>
          <div className="form-controls">
            <textarea
              ref="commentText"
              rows="5"
              placeholder="Write a comment..."
              required="true"/>
            <button type="submit">Save comment</button>
          </div>
        </form>
      </div>
    );
  }

  _handleCommentFormSubmit(e) {
    e.preventDefault();

    const { id } = this.props.card;
    const { channel, dispatch } = this.props;
    const { commentText } = this.refs;

    const comment = {
      card_id: id,
      text: commentText.value.trim(),
    };

    dispatch(Actions.createCardComment(channel, comment));

    commentText.value = '';
  }

  _renderComments(card) {
    if (card.comments.length == 0) return false;

    const comments = card.comments.map((comment) => {
      const { user } = comment;

      return (
        <div key={comment.id} className="comment">
          <div className="gravatar-wrapper">
            <ReactGravatar className="react-gravatar" email={user.email} https />
          </div>
          <div className="info-wrapper">
            <h5>{user.name}</h5>
            <div className="text">
              {comment.text}
            </div>
            <small>{moment(comment.inserted_at).fromNow()}</small>
          </div>
        </div>
      );
    });

    return (
      <div className="comments-wrapper">
        <h4>Activity</h4>
        {comments}
      </div>
    );
  }

  _handleHeaderClick(e) {
    e.preventDefault();

    const { dispatch } = this.props;
    dispatch(Actions.editCard(true));
  }

  _handleCancelClick(e) {
    e.preventDefault();
    const { dispatch } = this.props;
    dispatch(Actions.editCard(false));
  }

  _handleFormSubmit(e) {
    e.preventDefault();

    const { name, description } = this.refs;

    const { card } = this.props;

    card.name = name.value.trim();
    card.description = description.value.trim();

    const { channel, dispatch } = this.props;

    dispatch(BoardActions.updateCard(channel, card));
  }

  _renderHeader() {
    const { card, edit } = this.props;

    if (edit) {
      return (
        <header className="editing">
          <form onSubmit={::this._handleFormSubmit}>
            <input
              ref="name"
              type="text"
              placeholder="Title"
              required="true"
              defaultValue={card.name} />
            <textarea
              ref="description"
              type="text"
              placeholder="Description"
              rows="5"
              defaultValue={card.description} />
            <button type="submit">Save card</button> or <a href="#" onClick={::this._handleCancelClick}>cancel</a>
          </form>
        </header>
      );
    } else {
      return (
        <header>
          <h3>{card.name}</h3>
          <div className="items-wrapper">
            {::this._renderMembers()}
            {::this._renderType()}
            {::this._renderTags()}
          </div>
          <h5>Description</h5>
          <p>{card.description}</p>
          <a href="#" onClick={::this._handleHeaderClick}>Edit</a>
        </header>
      );
    }
  }

  _renderMembers() {
    const { members } = this.props.card;

    if (members.length == 0) return false;

    const memberNodes = members.map((member) => {
      return <ReactGravatar className="react-gravatar" key={member.id} email={member.email} https />;
    });

    return (
      <div className="card-members">
      <h5>Members</h5>
        {memberNodes}
      </div>
    );
  }

  _renderType() {
    const { type } = this.props.card;

    if (type === undefined) return false;

    return (
      <div className="card-type">
      <h5>Type</h5>
        <div key={type} className={`type ${type}`}>{type}</div>
      </div>
    );
  }

  _renderTags() {
    const { tags } = this.props.card;

    if (tags.length == 0) return false;

    const tagsNodes = tags.map((tag) => {
      return <div key={tag} className={`tag ${tag}`}></div>;
    });

    return (
      <div className="card-tags">
      <h5>Tags</h5>
        {tagsNodes}
      </div>
    );
  }

  _handleShowMembersClick(e) {
    e.preventDefault();

    const { dispatch } = this.props;

    dispatch(Actions.showMembersSelector(true));
  }

  _handleShowTagsClick(e) {
    e.preventDefault();

    const { dispatch } = this.props;

    dispatch(Actions.showTagsSelector(true));
  }

  _handleShowTypeClick(e) {
    e.preventDefault();

    const { dispatch } = this.props;

    dispatch(Actions.showTypeSelector(true));
  }

  _handleArchiveClick(e) {
    e.preventDefault();

    const { card, dispatch, channel, boardId } = this.props;

    dispatch(Actions.archiveCard(channel, card));
    dispatch(push(`/boards/${boardId}`));
  }

  _renderMembersSelector() {
    const { card, boardMembers, showMembersSelector, dispatch, channel } = this.props;
    const { members } = card;

    if (!showMembersSelector) return false;

    return (
      <MembersSelector
        channel={channel}
        cardId={card.id}
        dispatch={dispatch}
        boardMembers={boardMembers}
        selectedMembers={members}
        close={::this._onMembersSelectorClose} />
    );
  }

  _onMembersSelectorClose() {
    const { dispatch } = this.props;

    dispatch(Actions.showMembersSelector(false));
  }

  _renderTagsSelector() {
    const { card, showTagsSelector, dispatch, channel } = this.props;
    const { tags } = card;

    if (!showTagsSelector) return false;

    return (
      <TagsSelector
        channel={channel}
        cardId={card.id}
        dispatch={dispatch}
        selectedTags={tags}
        close={::this._onTagsSelectorClose} />
    );
  }

  _onTagsSelectorClose() {
    const { dispatch } = this.props;

    dispatch(Actions.showTagsSelector(false));
  }

  _renderTypeSelector() {
    const { card, showTypeSelector, dispatch, channel } = this.props;
    console.log(card);
    const { type } = card;

    if (!showTypeSelector) return false;

    return (
      <TypeSelector
        channel={channel}
        cardId={card.id}
        dispatch={dispatch}
        selectedType={type}
        close={::this._onTypeSelectorClose} />
    );
  }

  _onTypeSelectorClose() {
    const { dispatch } = this.props;

    dispatch(Actions.showTypeSelector(false));
  }

  render() {
    const { card, boardMembers, showMembersSelector } = this.props;
    const { members } = card;

    return (
      <div className="md-overlay">
        <div className="md-modal">
          <PageClick onClick={::this._closeModal}>
            <div className="md-content card-modal">
              <a className="close" href="#" onClick={::this._closeModal}>
                <i className="fa fa-close"/>
              </a>
              <div className="info">
                {::this._renderHeader()}
                {::this._renderCommentForm()}
                {::this._renderComments(card)}
              </div>
              <div className="options">
                <h4>Add</h4>
                <a className="button" href="#" onClick={::this._handleShowMembersClick}>
                  <i className="fa fa-user"/> Members
                </a>
                {::this._renderMembersSelector()}
                <a className="button" href="#" onClick={::this._handleShowTagsClick}>
                  <i className="fa fa-tags"/> Tags
                </a>
                {::this._renderTagsSelector()}
                <a className="button" id="type-selector-button" href="#" onClick={::this._handleShowTypeClick}>
                  <i className="fa fa-tag"/> Type
                </a>
                {::this._renderTypeSelector()}
                <a className="button" id="archive-button" href="#" onClick={::this._handleArchiveClick}>
                  <i className="fa fa-archive"/> Archive
                </a>
              </div>
            </div>
          </PageClick>
        </div>
      </div>
    );
  }
}

CardModal.propTypes = {
};
