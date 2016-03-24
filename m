Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3D90F1A1E89
 for <linux-nvdimm@lists.01.org>; Thu, 24 Mar 2016 06:51:12 -0700 (PDT)
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 11/13] libnvdimm, pmem,
 pfn: make pmem_rw_bytes generic and refactor pfn setup
Date: Thu, 24 Mar 2016 14:50:44 +0100
Message-ID: <5983443.ftVyGZcjEZ@c203>
In-Reply-To: <20160324012618.21436.3392.stgit@dwillia2-desk3.jf.intel.com>
References: <20160324012520.21436.22505.stgit@dwillia2-desk3.jf.intel.com>
 <20160324012618.21436.3392.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mittwoch, 23. M=E4rz 2016 18:26:18 CET Dan Williams wrote:
> In preparation for providing an alternative (to block device) access
> mechanism to persistent memory, convert pmem_rw_bytes() to
> nsio_rw_bytes().  This allows ->rw_bytes() functionality without
> requiring a 'struct pmem_device' to be instantiated.
> =

> In other words, when ->rw_bytes() is in use i/o is driven through
> 'struct nd_namespace_io', otherwise it is driven through 'struct
> pmem_device' and the block layer.  This consolidates the disjoint calls
> to devm_exit_badblocks() and devm_memunmap() into a common
> devm_nsio_disable() and cleans up the init path to use a unified
> pmem_attach_disk() implementation.
> =

> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

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
