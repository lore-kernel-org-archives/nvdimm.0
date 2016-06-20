Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from na01-bl2-obe.outbound.protection.outlook.com
 (mail-bl2on0683.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fc09::683])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DF3BB1A1E25
 for <linux-nvdimm@lists.01.org>; Mon, 20 Jun 2016 06:36:55 -0700 (PDT)
Subject: Re: [PATCH v3 1/3] block: introduce device_add_disk()
References: <146618127395.31030.11800447312061202344.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146618127928.31030.14749842741360356417.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Bart Van Assche <bart.vanassche@sandisk.com>
Message-ID: <dc24a951-eb95-c5bd-68e0-b553a1436ea0@sandisk.com>
Date: Mon, 20 Jun 2016 15:36:18 +0200
MIME-Version: 1.0
In-Reply-To: <146618127928.31030.14749842741360356417.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>, linux-block@vger.kernel.org
Cc: axboe@fb.com, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 06/17/2016 06:34 PM, Dan Williams wrote:
> In preparation for removing the ->driverfs_dev member of a gendisk, add
> an api that takes the parent device as a parameter to add_disk().  For
> now this maintains the status quo of WARN()ing on failure, but not
> return a error code.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
