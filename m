Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 54DC91A1E06
 for <linux-nvdimm@lists.01.org>; Fri,  2 Sep 2016 07:24:08 -0700 (PDT)
Date: Fri, 2 Sep 2016 16:24:05 +0200
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [ndctl PATCH 2/2] ndctl, util: add support for HPE DSM SMART
 interfaces
Message-ID: <20160902142405.frslxn2zocx5joga@c203.arch.suse.de>
References: <20160902133238.22200-1-brian.boylston@hpe.com>
 <20160902133238.22200-3-brian.boylston@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160902133238.22200-3-brian.boylston@hpe.com>
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
To: Brian Boylston <brian.boylston@hpe.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Sep 02, 2016 at 08:32:38AM -0500, Brian Boylston wrote:
> This patch introduces util_hpe_dimm_health_to_json(), which calls the HPE
> DSM functions defined in [1] and populates a JSON object with health data.
> This delivers health reporting parity for HPE type N NVDIMMs, but we are
> planning a future patch to export JSON for some of the additional health
> data defined in [1].
> =

> [1] https://github.com/HewlettPackard/hpe-nvm/raw/master/Documentation/NF=
IT_DSM_DDR4_NVDIMM-N_v84s.pdf
> =

> Cc: Dan Williams <dan.j.williams@intel.com>
> Reviewed-by: Jerry Hoemann <jerry.hoemann@hpe.com>
> Signed-off-by: Brian Boylston <brian.boylston@hpe.com>
> ---
>  ndctl/Makefile.am       |   1 +
>  ndctl/builtin-list.c    |   2 +
>  ndctl/util/json-hpe.c   | 283 ++++++++++++++++++++++++++++++++++++++++
>  ndctl/util/json.h       |   6 +
>  ndctl/util/ndctl-hpe1.h | 335 ++++++++++++++++++++++++++++++++++++++++++=
++++++
>  5 files changed, 627 insertions(+)
>  create mode 100644 ndctl/util/json-hpe.c
>  create mode 100644 ndctl/util/ndctl-hpe1.h
> =

> diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
> index 04f3a63..ee1e856 100644
> --- a/ndctl/Makefile.am
> +++ b/ndctl/Makefile.am
> @@ -48,6 +48,7 @@ ndctl_SOURCES =3D ndctl.c \
>  =

>  if ENABLE_SMART
>  ndctl_SOURCES +=3D util/json-smart.c
> +ndctl_SOURCES +=3D util/json-hpe.c
>  endif
>  =

>  if ENABLE_DESTRUCTIVE
> diff --git a/ndctl/builtin-list.c b/ndctl/builtin-list.c
> index 0875ca9..fb1a361 100644
> --- a/ndctl/builtin-list.c
> +++ b/ndctl/builtin-list.c
> @@ -316,6 +316,8 @@ int cmd_list(int argc, const char **argv)
>  				struct json_object *jhealth;
>  =

>  				jhealth =3D util_dimm_health_to_json(dimm);
> +				if (!jhealth)
> +					jhealth =3D util_hpe_dimm_health_to_json(dimm);

Try and error probing for the correct vendor? There surely must be a
better way to do.

But anyway nice job Brian (way better than my attempts to "live patch"
the ioctls in the kernel)

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
