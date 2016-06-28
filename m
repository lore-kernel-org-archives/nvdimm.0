Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from na01-bl2-obe.outbound.protection.outlook.com
 (mail-bl2on0642.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fc09::642])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0A14A1A1E03
 for <linux-nvdimm@lists.01.org>; Tue, 28 Jun 2016 00:30:56 -0700 (PDT)
Subject: Re: [PATCH v5 5/5] block: remove ->driverfs_dev
References: <146705579255.39775.12551436695635245858.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146705581912.39775.9811510607157155243.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Bart Van Assche <bart.vanassche@sandisk.com>
Message-ID: <138e3e1a-8987-4770-8155-482bfffe5804@sandisk.com>
Date: Tue, 28 Jun 2016 09:30:11 +0200
MIME-Version: 1.0
In-Reply-To: <146705581912.39775.9811510607157155243.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On 06/27/2016 09:30 PM, Dan Williams wrote:
> Now that all drivers that specify a ->driverfs_dev have been converted
> to device_add_disk(), the pointer can be removed from struct gendisk.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
