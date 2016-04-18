Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F2DAA1A2054
 for <linux-nvdimm@lists.01.org>; Mon, 18 Apr 2016 01:09:08 -0700 (PDT)
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [RFC v9 4/5] nvdimm: Add concept of cmd mask
Date: Mon, 18 Apr 2016 10:09:07 +0200
Message-ID: <11329369.6f8kWKfT6D@c203>
In-Reply-To: <f94e58ce44103ee3990e611ddb4e63269e278de3.1460936121.git.jerry.hoemann@hpe.com>
References: <cover.1460936121.git.jerry.hoemann@hpe.com>
 <f94e58ce44103ee3990e611ddb4e63269e278de3.1460936121.git.jerry.hoemann@hpe.com>
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

On Sonntag, 17. April 2016 17:38:46 CEST Jerry Hoemann wrote:
> DSMs have a mask of commands implemented on the DSM.
> =

> The current IOCTL interface exported for the NVDIMM DSM maps directly
> onto the underlying DSM.
> =

> With the addition of the pass thru mechanism, the IOCTL doesn't map
> directly onto the underlying DSM functions as the Pass thru isn't itself
> a DSM function and some DSM can use only the pass thru.
> =

> These changes separate out the concept of a command mask that applies
> to function that are supported by the IOCTL and a dsm mask that apply
> to the underlying firmware.
> =

> There is one noticiable exception, the cmd_mask =3D=3D the dsm_mask
> for root functions.
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
