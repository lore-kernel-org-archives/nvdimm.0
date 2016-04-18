Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4E25C1A2054
 for <linux-nvdimm@lists.01.org>; Mon, 18 Apr 2016 01:07:41 -0700 (PDT)
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [RFC v9 1/5] nvdimm: Add IOCTL pass thru functions
Date: Mon, 18 Apr 2016 10:07:37 +0200
Message-ID: <6468499.qEYKjyXnYB@c203>
In-Reply-To: <3e5bf78e359a066ae18debe3921d2f585060785e.1460936121.git.jerry.hoemann@hpe.com>
References: <cover.1460936121.git.jerry.hoemann@hpe.com>
 <3e5bf78e359a066ae18debe3921d2f585060785e.1460936121.git.jerry.hoemann@hpe.com>
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
List-ID: <linux-nvdimm@lists.01.org>

On Sonntag, 17. April 2016 17:38:43 CEST Jerry Hoemann wrote:
> Add ioctl command ND_CMD_CALL_DSM to acpi_nfit_ctl and __nd_ioctl which
> allow kernel to call a nvdimm's _DSM as a passthru without using the
> marshaling code of the nd_cmd_desc.
> =

> This supports DSM as defined in:
> =

>     http://pmem.io/documents/NVDIMM_DSM_Interface_Example.pdf
>     https://github.com/HewlettPackard/hpe-nvm/tree/master/Documentation
> =

> Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
> ---

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- =

Johannes Thumshirn                                                         =
                       Storage
jthumshirn@suse.de                                                         =
    +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
