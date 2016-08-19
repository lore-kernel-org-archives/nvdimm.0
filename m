Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B51CC1A1E08
 for <linux-nvdimm@lists.01.org>; Fri, 19 Aug 2016 01:17:41 -0700 (PDT)
Date: Fri, 19 Aug 2016 10:17:38 +0200
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2] libnvdimm: Fix nvdimm_probe error on NVDIMM-N
Message-ID: <20160819081738.ayh45ci4x3f7ykue@c203.arch.suse.de>
References: <1471374520-3331-1-git-send-email-toshi.kani@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1471374520-3331-1-git-send-email-toshi.kani@hpe.com>
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 16, 2016 at 01:08:40PM -0600, Toshi Kani wrote:
> 'ndctl list --buses --dimms' does not list any NVDIMM-Ns since
> they are considered as idle.  ndctl checks if any driver is
> attached to nmem device.  nvdimm_probe() always fails in
> nvdimm_init_nsarea() since NVDIMM-Ns do not implement optinal
> ND_CMD_GET_CONFIG_DATA command.
> =

> Change nvdimm_probe() to accept the case that the CONFIG_DATA
> command is not implemented for NVDIMM-Ns.  The driver attaches
> without ndd, which keeps it no-op to the device.
> =

> Reported-by: Brian Boylston <brian.boylston@hpe.com>
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Dan Williams <dan.j.williams@intel.com>

Tested-by: Johannes Thumshirn <jthumshirn@suse.de>
Acked-by: Johannes Thumshirn <jthumshirn@suse.de>

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
