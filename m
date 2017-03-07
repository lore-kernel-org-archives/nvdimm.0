Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1D17080347
 for <linux-nvdimm@lists.01.org>; Tue,  7 Mar 2017 01:31:37 -0800 (PST)
Subject: Re: [PATCH 5/5] libnvdimm: providing dax support for nvdimm testing
References: <148883211285.49239.17952572594430933942.stgit@djiang5-desk3.ch.intel.com>
 <148883237360.49239.7426828271089855600.stgit@djiang5-desk3.ch.intel.com>
From: Johannes Thumshirn <jthumshirn@suse.de>
Message-ID: <058053ab-4e36-6ba4-23b5-c14a476af3f1@suse.de>
Date: Tue, 7 Mar 2017 10:31:35 +0100
MIME-Version: 1.0
In-Reply-To: <148883237360.49239.7426828271089855600.stgit@djiang5-desk3.ch.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dave Jiang <dave.jiang@intel.com>, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 03/06/2017 09:32 PM, Dave Jiang wrote:
> Adding dax support to the nvdimm testing in tools/testing/nvdimm. The
> memory allocated by the tool is via vmalloc and non-contiguous.
> Overriding pgoff_to_phys() call to support the vmalloc memory.
> =

> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---

Thanks,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>


-- =

Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
