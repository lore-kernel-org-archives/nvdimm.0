Return-Path: <SRS0=GkZn=YW=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA919CA9EAE
	for <linux-nvdimm@archiver.kernel.org>; Tue, 29 Oct 2019 16:15:09 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CA3582087F
	for <linux-nvdimm@archiver.kernel.org>; Tue, 29 Oct 2019 16:15:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA3582087F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id C5E85100EA533;
	Tue, 29 Oct 2019 09:15:51 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=134.134.136.65; helo=mga03.intel.com; envelope-from=ira.weiny@intel.com; receiver=<UNKNOWN> 
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 3223C100EA531
	for <linux-nvdimm@lists.01.org>; Tue, 29 Oct 2019 09:15:48 -0700 (PDT)
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Oct 2019 09:15:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,244,1569308400";
   d="scan'208";a="202893270"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.157])
  by orsmga003.jf.intel.com with ESMTP; 29 Oct 2019 09:15:05 -0700
Date: Tue, 29 Oct 2019 09:15:05 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [ndctl patch 3/4] query_fw_finish_status: get rid of redundant
 variable
Message-ID: <20191029161504.GA12946@iweiny-DESK2.sc.intel.com>
References: <20191018202302.8122-1-jmoyer@redhat.com>
 <20191018202302.8122-4-jmoyer@redhat.com>
 <20191018205424.GA12760@iweiny-DESK2.sc.intel.com>
 <x49sgnp7ohp.fsf@segfault.boston.devel.redhat.com>
 <49b7cb5dae88ada6945b15eb1cf2e5e798173861.camel@intel.com>
 <7187044f4f6dca57f43879cd2d493949735f63a2.camel@intel.com>
 <20191025222115.GA6536@iweiny-DESK2.sc.intel.com>
 <x49v9s8veyb.fsf@segfault.boston.devel.redhat.com>
 <20191028211338.GA9826@iweiny-DESK2.sc.intel.com>
 <x49v9s834fs.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <x49v9s834fs.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Message-ID-Hash: HLF2BLBU6JDQJCFBJUCAQ2UH5JZDH7AP
X-Message-ID-Hash: HLF2BLBU6JDQJCFBJUCAQ2UH5JZDH7AP
X-MailFrom: ira.weiny@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/HLF2BLBU6JDQJCFBJUCAQ2UH5JZDH7AP/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Oct 28, 2019 at 06:12:23PM -0400, Jeff Moyer wrote:
> Ira Weiny <ira.weiny@intel.com> writes:
> 
> > On Mon, Oct 28, 2019 at 03:37:48PM -0400, Jeff Moyer wrote:
> >> Ira Weiny <ira.weiny@intel.com> writes:
> >> 
> >> >> (Watching the unit test run fall into an infinite loop..) Nope, the
> >> >> break is in the switch scope, the while loop needs the 'goto out'.
> >> >> 
> >> >> Yes this bit definitely needs to be refactored :)
> >> >
> >> > How about this patch instead?  Untested.
> >> 
> >> I'm not a fan of the looping with gotos.
> >
> > Me either... But... the logic here is not the same.
> 
> How about this one, then?  Again, compile-tested only.  I'll run it
> through testing only if you like it better than your approach.  If you
> like your appraoch better, I'll go ahead and review and test that.
> 
> Cheers,
> Jeff
> 
> diff --git a/ndctl/dimm.c b/ndctl/dimm.c
> index b1b84c2..63d4d4a 100644
> --- a/ndctl/dimm.c
> +++ b/ndctl/dimm.c
> @@ -674,6 +674,52 @@ out:
>  	return rc;
>  }
>  
> +/*
> + * Wait for a command to complete, up to the firmware-specified timeout.
> + * Returns -errno on error.  On success, which means either the command
> + * completed (sucessfully or with an error), or we timed out waiting for
> + * it, return 0.  The caller needs to check the status on its own if this
> + * function returns 0.
> + */
> +static int query_fw_finish_status_timeout(struct ndctl_cmd *cmd,
> +					  struct fw_info *fw)
> +{
> +	enum ND_FW_STATUS status;
> +	struct timespec sleeptime, start, now;
> +	int rc;
> +
> +	rc = clock_gettime(CLOCK_MONOTONIC, &start);
> +	if (rc < 0)
> +		return rc;
> +
> +	sleeptime.tv_nsec = fw->query_interval / 1000;
> +	sleeptime.tv_sec = 0;
> +
> +	while ((rc = ndctl_cmd_submit(cmd)) == 0 &&

This needs to check for >= 0 because ndctl_cmd_submit() can return a positive
value on success.  See do_cmd()

> +	       (status = ndctl_cmd_fw_xlat_firmware_status(cmd)) == FW_EBUSY) {

Why not return this status rather than having to query for it again?

While I'm not a fan of the goto either I think it does actually work ok.

Why don't we go with that patch for now and if you want to pull the "again"
loop into a separate function which fixes the signal handling of nanosleep we
can do that as a follow on.

But I think we need to fix the above and just return the status from this
loop...

Something like:

static int query_fw_finish_status_timeout(struct ndctl_cmd *cmd,
					  struct fw_info *fw,
					  enum ND_FW_STATUS *status)
{
	...
}

[snip]

> -		status = ndctl_cmd_fw_xlat_firmware_status(cmd);
> -		switch (status) {
> -		case FW_SUCCESS:
> -			ver = ndctl_cmd_fw_fquery_get_fw_rev(cmd);
> -			if (ver == 0) {
> -				fprintf(stderr, "No firmware updated.\n");
> -				rc = -ENXIO;
> -				goto out;
> -			}
> -
> -			printf("Image updated successfully to DIMM %s.\n",
> -					ndctl_dimm_get_devname(dimm));
> -			printf("Firmware version %#lx.\n", ver);
> -			printf("Cold reboot to activate.\n");

[snip]

>  		}
> -	} while (true);
>  
> -out:
> +		printf("Image updated successfully to DIMM %s.\n",
> +		       ndctl_dimm_get_devname(dimm));
> +		printf("Firmware version %#lx.\n", ver);
> +		printf("Cold reboot to activate.\n");

Final NIT I changed these to fprintf() as well.

Ira
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
