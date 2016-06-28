Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from na01-by2-obe.outbound.protection.outlook.com
 (mail-by2on0640.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fc0c::640])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B23AF1A1E03
 for <linux-nvdimm@lists.01.org>; Tue, 28 Jun 2016 00:23:53 -0700 (PDT)
Subject: Re: [PATCH v5 3/5] um: track 'parent' device in a local variable
References: <146705579255.39775.12551436695635245858.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146705580842.39775.16180359577535598750.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Bart Van Assche <bart.vanassche@sandisk.com>
Message-ID: <5965be1f-6b0b-d6f7-f6b0-d73b9be87267@sandisk.com>
Date: Tue, 28 Jun 2016 09:23:05 +0200
MIME-Version: 1.0
In-Reply-To: <146705580842.39775.16180359577535598750.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>, axboe@fb.com
Cc: linux-nvdimm@lists.01.org, Richard Weinberger <richard@nod.at>, Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On 06/27/2016 09:30 PM, Dan Williams wrote:
> In preparation for the removal of 'driverfs_dev' from 'struct gendisk'
> use a local variable to track the parented vs un-parented case in
> ubd_disk_register().

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
