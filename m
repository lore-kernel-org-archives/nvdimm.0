Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 324A0223FCF2F
 for <linux-nvdimm@lists.01.org>; Thu, 15 Mar 2018 01:04:57 -0700 (PDT)
Date: Thu, 15 Mar 2018 09:11:18 +0100
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 0/3] Introduce module_nd_driver
Message-ID: <20180315081118.vivohgn6vrt74pyc@linux-x5ow.site>
References: <20180314182508.10351-1-jthumshirn@suse.de>
 <20180315072257.GA14576@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180315072257.GA14576@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux NV-DIMM Mailing List <linux-nvdimm@lists.01.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 15, 2018 at 12:22:57AM -0700, Christoph Hellwig wrote:
> What is the point?  It saves a hand fulk of lines, while making
> the code both harder to read and harder to extend.

In the end it's just style alignment with most of the other "busses"
in the kernel, like pci, of, acpi, platform and so on...

But yes I admit it's not a huge win. For the harder to read part, I
doubt it. A quick:
git grep -E module_.*._driver drivers/ | wc -l
has 3896 hit's, so it's not that uncommon ;-)

But anyways, it's just code churn I came up with while being
frustrated hunting down a bug in this subsystem.

Byte,
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
