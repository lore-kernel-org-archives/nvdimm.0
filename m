Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5EA6B21B06E91
 for <linux-nvdimm@lists.01.org>; Tue, 25 Jul 2017 13:44:10 -0700 (PDT)
Date: Tue, 25 Jul 2017 16:46:09 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm,dax: Make sure dm_dax_flush() is called if device supports it
Message-ID: <20170725204608.GA27693@redhat.com>
References: <20170725194337.GA20979@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170725194337.GA20979@redhat.com>
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: dm-devel@redhat.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 25 2017 at  3:43pm -0400,
Vivek Goyal <vgoyal@redhat.com> wrote:

> Right now, dm_dax_flush() is not being called and I think it is not being
> called becuase DAXDEV_WRITE_CACHE is not set on dm dax device.
> 
> If underlying dax device supports write cache, set DAXDEV_WRITE_CACHE on
> dm dax device. This will get dm_dax_flush() being called.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

In general this looks mostly OK.. but it seems a bit weird to on the one
hand: test if DAXDEV_WRITE_CACHE is set on underlying device.  And on
the other: say it is a write cache because it is "flush_capable".  Kind
of blurring things a bit.

Why not s/device_dax_flush_capable/device_dax_write_cache_enabled/ ?

Mike
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
