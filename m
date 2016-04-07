Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3059D1A1E55
 for <linux-nvdimm@lists.01.org>; Thu,  7 Apr 2016 01:41:06 -0700 (PDT)
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [ndctl PATCH 4/5] ndctl, list: add a '--health' option
Date: Thu, 07 Apr 2016 10:41:04 +0200
Message-ID: <1502009.VVHIfC1a8J@c203>
In-Reply-To: <20160407010720.30641.60021.stgit@dwillia2-desk3.jf.intel.com>
References: <20160407010659.30641.26139.stgit@dwillia2-desk3.jf.intel.com>
 <20160407010720.30641.60021.stgit@dwillia2-desk3.jf.intel.com>
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

On Mittwoch, 6. April 2016 18:07:20 CEST Dan Williams wrote:
> Dump dimm smart data in the dimm listing when '--health' is specified.
> =

> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

[...]

> @@ -200,6 +201,7 @@ int cmd_list(int argc, const char **argv)
>  				"filter by region-type"),
>  		OPT_BOOLEAN('B', "buses", &list.buses, "include bus info"),
>  		OPT_BOOLEAN('D', "dimms", &list.dimms, "include dimm info"),
> +		OPT_BOOLEAN('H', "health", &list.health, "include dimm health"),
>  		OPT_BOOLEAN('R', "regions", &list.regions,
>  				"include region info"),
>  		OPT_BOOLEAN('N', "namespaces", &list.namespaces,
> @@ -299,6 +301,15 @@ int cmd_list(int argc, const char **argv)
>  				continue;
>  			}
> =

> +			if (list.health) {
> +				struct json_object *jhealth;
> +
> +				jhealth =3D util_dimm_health_to_json(dimm);
> +				if (jhealth)
> +					json_object_object_add(jdimm, "health",
> +							jhealth);

Maybe some sort of error message for the else path? Either here or in =

util_dimm_health_to_json()?

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
