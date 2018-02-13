Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4123621CF1CEF
 for <linux-nvdimm@lists.01.org>; Tue, 13 Feb 2018 05:19:15 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] ndctl: add option to list firmware information for a DIMM
References: <151848066201.13592.3757378386488366418.stgit@djiang5-desk3.ch.intel.com>
Date: Tue, 13 Feb 2018 08:25:04 -0500
In-Reply-To: <151848066201.13592.3757378386488366418.stgit@djiang5-desk3.ch.intel.com>
 (Dave Jiang's message of "Mon, 12 Feb 2018 17:11:02 -0700")
Message-ID: <x497erhqaxb.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi, Dave,

Dave Jiang <dave.jiang@intel.com> writes:

> Adding firmware output of firmware information when ndctl list -D -F is used.
> Components displayed are current firmware version, updated firmware version,
> and if a coldboot is required (firmware updated).
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  Documentation/ndctl/ndctl-list.txt |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> @@ -420,6 +422,25 @@ int cmd_list(int argc, const char **argv, void *ctx)
>  				}
>  			}
>  
> +			if (list.firmware) {
> +				struct json_object *jfirmware;
> +
> +				jfirmware = util_dimm_firmware_to_json(dimm);
> +				if (jfirmware)
> +					json_object_object_add(jdimm,
> +							"firmware",
> +							jfirmware);
> +				else if (ndctl_dimm_is_cmd_supported(dimm,
> +							ND_CMD_CALL)) {
> +					/*
> +					 * Failed to retrieve firmware
> +					 * version.
> +					 */
> +					fail("\n");

I'm hitting this failure.  Also, you might consider adding some text,
there.  :)

-Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
