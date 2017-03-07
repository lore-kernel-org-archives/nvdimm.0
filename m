Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3DD1F8034E
 for <linux-nvdimm@lists.01.org>; Tue,  7 Mar 2017 08:11:26 -0800 (PST)
Subject: Re: [PATCH 4/5] acpi_nfit, libnvdimm: Add support for clear poison
 list and bad blocks
References: <148883211285.49239.17952572594430933942.stgit@djiang5-desk3.ch.intel.com>
 <148883236818.49239.12371446691877974041.stgit@djiang5-desk3.ch.intel.com>
 <ca401cc3-db44-32a7-ecc5-2c06c0322177@suse.de>
 <7c50af6b-558d-76c8-faae-228e224fae75@intel.com>
From: Johannes Thumshirn <jthumshirn@suse.de>
Message-ID: <56e65362-20b9-46d5-49c7-d70d702c1743@suse.de>
Date: Tue, 7 Mar 2017 17:11:23 +0100
MIME-Version: 1.0
In-Reply-To: <7c50af6b-558d-76c8-faae-228e224fae75@intel.com>
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

On 03/07/2017 05:00 PM, Dave Jiang wrote:
> So if nd_btt->ndns or nd_pfn->ndns or nd_dax->nd_pfn.ndns happens to be
> NULL, then this case can happen. I don't know how likely that is to
> happen however. The code was lifted from nvdimm_namespace_common_probe().

Ah right, I just looked at the 'if (nd_btt || nd_pfn || nd_dax)' and
then missed out the *->ndns assignments.

Thanks,
	Johannes

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
