# ZNStickyRefresher
A classic refresh effect called sticky candy at QQ in iOS. (simple simulation)

You can use it by those codes:

```
lazy var stickyRefreshControl: ZNStickyRefreshControl = {
  let result = ZNStickyRefreshControl()
  result.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
  return result
}()

tableView.addSubview(stickyRefreshControl)

@objc private func loadData() {
  // simulate network time waste
  DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { 
    self.cellsCount += 1
            
    self.tableView.reloadData()
            
    // if refresh failed, modify result tag
    //self.stickyRefreshControl.isSuccessful = false
            
    self.stickyRefreshControl.endRefreshing()
  }
}
```

The next gif show the effect:<br></br>
![image](https://github.com/ZeroOnet/ZNStickyRefresher/blob/master/ZNStickyRefresher/ZNStickyRefresher/Dispaly/display.gif)

You can know it with this blog: http://blog.csdn.net/ZeroOnet/article/details/78160592 (Chinese, ^_^)
