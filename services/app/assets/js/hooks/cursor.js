const TrackClientCursor = {
  mounted() {
    document.addEventListener('mousemove', (e) => {
      const mouse_x = (e.pageX / window.innerWidth) * 100; // in %
      const mouse_y = (e.pageY / window.innerHeight) * 100; // in %
      this.pushEvent('cursor-move', { mouse_x, mouse_y });
    });
  }
};
  
export default TrackClientCursor;
