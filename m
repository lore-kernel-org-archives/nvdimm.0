Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 82B19211F1E3F
 for <linux-nvdimm@lists.01.org>; Tue,  2 Apr 2019 07:29:39 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x32ETbbw029387
 for <linux-nvdimm@lists.01.org>; Tue, 2 Apr 2019 10:29:38 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2rm9e0rjuv-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Tue, 02 Apr 2019 10:29:38 -0400
Received: from localhost
 by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <paulmck@linux.vnet.ibm.com>;
 Tue, 2 Apr 2019 15:29:36 +0100
From: "Paul E. McKenney" <paulmck@linux.ibm.com>
Subject: [PATCH RFC tip/core/rcu 1/4] dax/super: Dynamically allocate dax_srcu
Date: Tue,  2 Apr 2019 07:29:30 -0700
In-Reply-To: <20190402142816.GA13084@linux.ibm.com>
References: <20190402142816.GA13084@linux.ibm.com>
Message-Id: <20190402142933.14547-1-paulmck@linux.ibm.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: rcu@vger.kernel.org
Cc: peterz@infradead.org, fweisbec@gmail.com, jiangshanlai@gmail.com, oleg@redhat.com, edumazet@google.com, joel@joelfernandes.org, "Paul E. McKenney" <paulmck@linux.ibm.com>, mingo@kernel.org, linux-nvdimm@lists.01.org, dipankar@in.ibm.com, josh@joshtriplett.org, rostedt@goodmis.org, mathieu.desnoyers@efficios.com, tglx@linutronix.de, dhowells@redhat.com, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

Having DEFINE_SRCU() or DEFINE_STATIC_SRCU() in a loadable module
requires that the size of the reserved region be increased, which is
not something we really want to be doing.  This commit therefore removes
the DEFINE_STATIC_SRCU() from drivers/dax/super.c in favor of defining
dax_srcu as a simple srcu_struct, initializing it in dax_core_init(),
and cleaning it up in dax_core_exit().

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: <linux-nvdimm@lists.01.org>
---
 drivers/dax/super.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 0a339b85133e..3b152db30c6b 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -25,7 +25,7 @@
 #include "dax-private.h"
 
 static dev_t dax_devt;
-DEFINE_STATIC_SRCU(dax_srcu);
+static struct srcu_struct dax_srcu;
 static struct vfsmount *dax_mnt;
 static DEFINE_IDA(dax_minor_ida);
 static struct kmem_cache *dax_cache __read_mostly;
@@ -665,6 +665,10 @@ static int __init dax_core_init(void)
 {
 	int rc;
 
+	rc = init_srcu_struct(&dax_srcu);
+	if (rc)
+		goto err_srcu;
+
 	rc = dax_fs_init();
 	if (rc)
 		return rc;
@@ -678,10 +682,13 @@ static int __init dax_core_init(void)
 		goto err_bus;
 	return 0;
 
+
 err_bus:
 	unregister_chrdev_region(dax_devt, MINORMASK+1);
 err_chrdev:
 	dax_fs_exit();
+	cleanup_srcu_struct(&dax_srcu);
+err_srcu:
 	return 0;
 }
 
@@ -690,6 +697,7 @@ static void __exit dax_core_exit(void)
 	unregister_chrdev_region(dax_devt, MINORMASK+1);
 	ida_destroy(&dax_minor_ida);
 	dax_fs_exit();
+	cleanup_srcu_struct(&dax_srcu);
 }
 
 MODULE_AUTHOR("Intel Corporation");
-- 
2.17.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
