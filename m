Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from na01-bl2-obe.outbound.protection.outlook.com
 (mail-bl2on0697.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fc09::697])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 74E831A1E03
 for <linux-nvdimm@lists.01.org>; Tue, 28 Jun 2016 00:37:48 -0700 (PDT)
Subject: Re: [PATCH v5 4/5] block: convert to device_add_disk()
References: <146705579255.39775.12551436695635245858.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146705581355.39775.16995803612126463831.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Bart Van Assche <bart.vanassche@sandisk.com>
Message-ID: <b4798a72-54f2-9b07-d13a-6eaf90cedb1a@sandisk.com>
Date: Tue, 28 Jun 2016 09:36:59 +0200
MIME-Version: 1.0
In-Reply-To: <146705581355.39775.16995803612126463831.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Keith Busch <keith.busch@intel.com>, "Martin K." Petersen" <martin.petersen@oracle.com>, "Michael S.Tsirkin" <mst@redhat.com>," linux-kernel@vger.kernel.org, hch@lst.de, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>, "David S. Miller" <davem@davemloft.net>
List-ID: <linux-nvdimm@lists.01.org>

On 06/27/2016 09:30 PM, Dan Williams wrote:
> For block drivers that specify a parent device, convert them to use
> device_add_disk().

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
