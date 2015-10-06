let gutterSize = 35;
let tabletBreakpoint = 1024;

const calculateHeight = (height) => {
  return Math.ceil(height/gutterSize) * gutterSize + 2 * gutterSize - 2;
}

class About extends React.Component {

  // static propTypes = {
  //   text: React.PropTypes.string.isRequired
  // }

  constructor(props) {
    super(props);

    this.state = {
      expanded: false
    };
    this.updateHeight = this.updateHeight.bind(this);
  }

  componentDidMount() {
    this.updateHeight();
    window.addEventListener('resize orientationchange', this.updateHeight);
  }

  componentDidUnmount() {
    window.removeEventListener('resize orientationchange', this.updateHeight);
  }


  updateHeight() {
    let height;

    if ($(window).width() < tabletBreakpoint) {
      let firstParagraphHeight = $container.find('p').height();
      height = calculateHeight(firstParagraphHeight);
    } else {
      height = 5 * gutterSize - 2;
    }

    this.lastHeight = height;
    this.setState({ height });
  }

  getText() {
    return { __html: this.props.text };
  }

  expand(event) {
    event.preventDefault();

    this.setState({ 
      expanded: !this.state.expanded,
      height:   this.lastHeight
    });
  }

  render() {
    return (
      <section 
        ref       = "main"
        className = { classNames({ expanded: this.state.expanded }) } 
        style     = { { height: this.state.height + 'px' } }
        id        = "about">
        <header>
          About
        </header>
        <div className="wrapper">
          <div 
            className = "content"
            dangerouslySetInnerHTML = { this.getText() } />
        </div>
        <button 
          onClick   = { this.expand.bind(this) }
          className = "expander">
          <i className="d4zed-icon-close" />
          <i className="d4zed-icon-expand" />
        </button>
      </section>
    );
  }

}