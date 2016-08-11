Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id 6DBE51A1DF1
 for <linux-nvdimm@lists.01.org>; Wed, 10 Aug 2016 21:51:46 -0700 (PDT)
Subject: [PATCH] fs/char_dev: fix cdev_put() vs f_op->release() use-after-free
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 10 Aug 2016 21:49:22 -0700
Message-ID: <147089096242.9037.17705831938180576705.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

drivers/dax/dax.c implements a character device that supports mmap().
While trying to convert it to use the cdev api a unit test started
failing. The test effectively does the following to test that the driver
revokes active mappings when the device is unregistered:

    fd = open("/dev/dax0.0", ...);
    mmap(..., fd, ...);
    <twiddle sysfs to trigger device_unregister()>;
    exit();

...results in this crash:

    dax dax0.0: dax_dev_vm_close
    dax dax0.0: dax_dev_release: ffff880338afd298
    dax_dev_free: ffff880338afd298
    general protection fault: 0000 [#1] SMP
    [..]
    Call Trace:
     [<ffffffff8128e2c0>] cdev_put+0x20/0x30
     [<ffffffff8128b4db>] __fput+0x1ab/0x1f0
     [<ffffffff8128b55e>] ____fput+0xe/0x10
     [<ffffffff810d371e>] task_work_run+0x7e/0xa0
     [<ffffffff810b41b2>] do_exit+0x302/0xc10

Where dax_dev_release() is the f_op->release() method, and is
implemented to simply drop the final references on our driver objects:

        struct dax_dev *dax_dev = filp->private_data;
        struct device *dev = dax_dev->dev;

        dev_dbg(dax_dev->dev, "%s\n", __func__);
        put_device(dev);
        dax_dev_put(dax_dev);

The dax_dev object embeds a 'struct cdev' which means f_op->release()
may free cdev, so __fput() needs to drop the cdev reference before
calling f_op->release().

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/file_table.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index ad17e05ebf95..8856b8008248 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -204,13 +204,13 @@ static void __fput(struct file *file)
 			file->f_op->fasync(-1, file, 0);
 	}
 	ima_file_free(file);
-	if (file->f_op->release)
-		file->f_op->release(inode, file);
-	security_file_free(file);
 	if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL &&
 		     !(file->f_mode & FMODE_PATH))) {
 		cdev_put(inode->i_cdev);
 	}
+	if (file->f_op->release)
+		file->f_op->release(inode, file);
+	security_file_free(file);
 	fops_put(file->f_op);
 	put_pid(file->f_owner.pid);
 	if ((file->f_mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
