import React, {PropTypes} from 'react';
import PageClick          from 'react-page-click';
import ReactGravatar      from 'react-gravatar';
import classnames         from 'classnames';

import Actions            from '../../actions/current_card';

export default class TypeSelector extends React.Component {
  _close(e) {
    e.preventDefault();

    this.props.close();
  }

  _changeType(type) {
    const { dispatch, channel, cardId } = this.props;

    dispatch(Actions.updateType(channel, cardId, type));
  }

  _renderTypesList() {
    const { selectedType } = this.props;

    const types = ['bug', 'feature', 'improvement', 'task'];

    const typeNodes = types.map((type) => {
      const isSelected = -1 != selectedType.indexOf(type);

      const handleOnClick = (e) => {
        e.preventDefault();

        return isSelected ? false : this._changeType(type);
      };

      const linkClasses = classnames({
        selected: isSelected,
      });

      const iconClasses = classnames({
        fa: true,
        'fa-check': isSelected,
      });

      const icon = (<i className={iconClasses}/>);

      return (
        <li key={type}>
          <a className={`type ${type} ${linkClasses}`} onClick={handleOnClick} href="#">
            {type} {icon}
          </a>
        </li>
      );
    });

    return (
      <ul>
        {typeNodes}
      </ul>
    );
  }

  render() {
    return (
      <PageClick onClick={::this._close}>
        <div className="type-selector">
          <header>Type <a className="close" onClick={::this._close} href="#"><i className="fa fa-close" /></a></header>
          {::this._renderTypesList()}
        </div>
      </PageClick>
    );
  }
}

TypeSelector.propTypes = {
};
