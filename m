Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Fri, 21 Jul 2017 02:56:34 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <945864462.33340808.1500620194836.JavaMail.zimbra@redhat.com>
In-Reply-To: <1455443283.33337333.1500618150787.JavaMail.zimbra@redhat.com>
Subject: KVM "fake DAX" flushing interface - discussion
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: kvm-devel <kvm@vger.kernel.org>, Qemu Developers <qemu-devel@nongnu.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>
Cc: Kevin Wolf <kwolf@redhat.com>, Rik van Riel <riel@redhat.com>, xiaoguangrong.eric@gmail.com, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>


Hello,

We shared a proposal for 'KVM fake DAX flushing interface'.

https://lists.gnu.org/archive/html/qemu-devel/2017-05/msg02478.html

We did initial POC in which we used 'virtio-blk' device to perform 
a device flush on pmem fsync on ext4 filesystem. They are few hacks 
to make things work. We need suggestions on below points before we 
start actual implementation.

A] Problems to solve:
------------------

1] We are considering two approaches for 'fake DAX flushing interface'.
    
 1.1] fake dax with NVDIMM flush hints & KVM async page fault

     - Existing interface.

     - The approach to use flush hint address is already nacked upstream.

     - Flush hint not queued interface for flushing. Applications might 
       avoid to use it.

     - Flush hint address traps from guest to host and do an entire fsync 
       on backing file which itself is costly.

     - Can be used to flush specific pages on host backing disk. We can 
       send data(pages information) equal to cache-line size(limitation) 
       and tell host to sync corresponding pages instead of entire disk sync.

     - This will be an asynchronous operation and vCPU control is returned 
       quickly.


 1.2] Using additional para virt device in addition to pmem device(fake dax with device flush)

     - New interface

     - Guest maintains information of DAX dirty pages as exceptional entries in 
       radix tree.

     - If we want to flush specific pages from guest to host, we need to send 
       list of the dirty pages corresponding to file on which we are doing fsync.

     - This will require implementation of new interface, a new paravirt device 
       for sending flush requests.

     - Host side will perform fsync/fdatasync on list of dirty pages or entire 
       block device backed file.

2] Questions:
-----------

 2.1] Not sure why WPQ flush is not a queued interface? We can force applications 
      to call this? device DAX neither calls fsync/msync?

 2.2] Depending upon interface we decide, we need optimal solution to sync 
      range of pages?

     - Send range of pages from guest to host to sync asynchronously instead 
       of syncing entire block device?

     - Other option is to sync entire disk backing file to make sure all the 
       writes are persistent. In our case, backing file is a regular file on 
       non NVDIMM device so host page cache has list of dirty pages which
       can be used either with fsync or similar interface.

 2.3] If we do host fsync on entire disk we will be flushing all the dirty data
      to backend file. Just thinking what would be better approach, flushing 
      pages on corresponding guest file fsync or entire block device?

 2.4] If we decide to choose one of the above approaches, we need to consider 
      all DAX supporting filesystems(ext4/xfs). Would hooking code to corresponding
      fsync code of fs seems reasonable? Just thinking for flush hint address use-case?
      Or how flush hint addresses would be invoked with fsync or similar api?

 2.5] Also with filesystem journalling and other mount options like barriers, 
      ordered etc, how we decide to use page flush hint or regular fsync on file?
 
 2.6] If at guest side we have PFN of all the dirty pages in radixtree? and we send 
      these to to host? At host side would we able to find corresponding page and flush 
      them all?

Suggestions & ideas are welcome.

Thanks,
Pankaj

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
