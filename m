Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com
 [209.85.210.196])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1BA252117FD44
 for <linux-nvdimm@lists.01.org>; Thu,  8 Nov 2018 15:47:03 -0800 (PST)
Received: by mail-pf1-f196.google.com with SMTP id y18-v6so38144pfn.1
 for <linux-nvdimm@lists.01.org>; Thu, 08 Nov 2018 15:47:03 -0800 (PST)
Message-ID: <1541720820.196084.238.camel@acm.org>
Subject: Re: [driver-core PATCH v6 5/9] driver core: Establish clear order
 of operations for deferred probe and remove
From: Bart Van Assche <bvanassche@acm.org>
Date: Thu, 08 Nov 2018 15:47:00 -0800
In-Reply-To: <154170042611.12967.14256799141542560553.stgit@ahduyck-desk1.jf.intel.com>
References: <154170028986.12967.2108024712555179678.stgit@ahduyck-desk1.jf.intel.com>
 <154170042611.12967.14256799141542560553.stgit@ahduyck-desk1.jf.intel.com>
Mime-Version: 1.0
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
To: Alexander Duyck <alexander.h.duyck@linux.intel.com>, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc: len.brown@intel.com, linux-pm@vger.kernel.org, rafael@kernel.org, jiangshanlai@gmail.com, linux-nvdimm@lists.01.org, pavel@ucw.cz, zwisler@kernel.org, tj@kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2018-11-08 at 10:07 -0800, Alexander Duyck wrote:
> One change I made in addition is I replaced the use of "bool X:1" to define
> the bitfield to a "u8 X:1" setup in order to resolve some checkpatch
> warnings.

If you have to repost this patch series please remove the above from the
patch description since I think this part is no longer relevant. Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
