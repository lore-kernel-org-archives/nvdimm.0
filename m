Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C537F21AEB0A6
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jul 2017 07:45:18 -0700 (PDT)
Date: Wed, 26 Jul 2017 10:46:39 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH][V2] dm, dax: Make sure dm_dax_flush() is called if device
 supports it
Message-ID: <20170726144639.GA32510@redhat.com>
References: <20170726133509.GA5416@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170726133509.GA5416@redhat.com>
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

On Wed, Jul 26 2017 at  9:35am -0400,
Vivek Goyal <vgoyal@redhat.com> wrote:

> Right now, dm_dax_flush() is not being called and I think it is not being
> called becuase DAXDEV_WRITE_CACHE is not set on dm dax device.
> 
> If underlying dax device supports write cache, set DAXDEV_WRITE_CACHE on
> dm dax device. This will get dm_dax_flush() being called.
> 
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

I tweaked the header a bit and staged for 4.13-rc3 here:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-4.13/dm&id=325ab51b81ca2a84ffd434652273eb5d8a8a5750

Thanks!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
