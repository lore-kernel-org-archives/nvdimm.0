Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x22a.google.com (mail-io0-x22a.google.com
 [IPv6:2607:f8b0:4001:c06::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9A3571A1FB4
 for <linux-nvdimm@lists.01.org>; Fri,  8 Jul 2016 15:05:56 -0700 (PDT)
Received: by mail-io0-x22a.google.com with SMTP id f30so55124613ioj.2
 for <linux-nvdimm@lists.01.org>; Fri, 08 Jul 2016 15:05:14 -0700 (PDT)
Subject: Re: [GIT PULL] ->driverfs_dev removal for 4.8
References: <1468015016.19315.10.camel@intel.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <57802398.2010105@kernel.dk>
Date: Fri, 8 Jul 2016 16:05:12 -0600
MIME-Version: 1.0
In-Reply-To: <1468015016.19315.10.camel@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "axboe@fb.com" <axboe@fb.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 07/08/2016 03:56 PM, Williams, Dan J wrote:
> Hi Jens, please pull from:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm for-4.8/block
>
> ...to receive:
>
> The removal of ->driverfs_dev in favor of just passing the parent
> device in as a parameter to add_disk().  See below, it has received a
> "Reviewed-by" from Christoph, Bart, and Johannes.
>
> It is also a pre-requisite for Fam Zheng's work to cleanup gendisk
> uevents vs attribute visibility [1].  We would extend device_add_disk()
> to take an attribute_group list.
>
> This is based off a branch of block.git/for-4.8/drivers and has
> received a positive build success notification from the kbuild robot
> across several configs.
>
> [1]: "gendisk: Generate uevent after attribute available"
> http://marc.info/?l=linux-virtualization&m=146725201522201&w=2

Pulled, thanks Dan.

-- 
Jens Axboe

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
