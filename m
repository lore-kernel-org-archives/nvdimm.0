Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22c.google.com (mail-ot0-x22c.google.com
 [IPv6:2607:f8b0:4003:c0f::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5EBC221A10961
 for <linux-nvdimm@lists.01.org>; Fri,  1 Dec 2017 15:32:34 -0800 (PST)
Received: by mail-ot0-x22c.google.com with SMTP id o23so10442983otd.1
 for <linux-nvdimm@lists.01.org>; Fri, 01 Dec 2017 15:37:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <151217066885.28402.7962437173336388439.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151217066885.28402.7962437173336388439.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 1 Dec 2017 15:36:59 -0800
Message-ID: <CAPcyv4hMopLsHCo2=42-Y2ymLMLTPDVXVGQmyvsw4t8Da4t91Q@mail.gmail.com>
Subject: Re: [ndctl PATCH 00/16] ndctl: update SMART support for
 NVDIMM_FAMILY_INTEL
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: Lijun Pan <Lijun.Pan@dell.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Dec 1, 2017 at 3:24 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>
> The v1.6 release of the NVDIMM_FAMILY_INTEL DSM specification [1]
> updates the format of the 'SMART Threshold Command' payload and
> introduces the 'SMART Set Threshold Command'. Given that the new SMART
> Threshold format is broken with respect to the initial / generic
> ND_IOCTL_SMART_THRESHOLD format the generic SMART commands are now
> deprecated. The NVDIMM_FAMILY_INTEL SMART support is updated to use
> the ND_IOCTL_CALL path similar to how libndctl abstracts the per vendor
> differences of the NVDIMM_FAMILY_{HPE1,MSFT} SMART implementations.
>
> Included in this overhaul is better infrastructure for supporting the
> rest of the v1.6 DSMs that need to go through the ND_IOCTL_CALL
> interface.
>
> Note, the v1.6 specification also includes a 'SMART Error Injection'
> facility, but that enabling is deferred for a later update and will be
> integrated with the 'ndctl inject-error' command.
>
> [1]: http://pmem.io/documents/NVDIMM_DSM_Interface-V1.6.pdf
>
> ---
>
> Dan Williams (16):
>       libndctl: rename dimm dsm_mask to cmd_mask
>       libndctl: add nfit_dsm_mask as a private dimm property
>       ndctl, smart: rename 'temperature' helpers to 'media_temperature'
>       ndctl, intel: switch to ND_CMD_CALL passthrough for SMART commands
>       ndctl: remove support for compiling against the kernel ndctl.h header
>       ndctl, test: emit smart field names
>       ndctl, smart: cleanup smart_cmd_op() macro
>       ndctl, test: reset all nfit_test data for each test/libndctl run
>       ndctl, region: cleanup error message
>       ndctl: support set smart alarm/threshold
>       ndctl: refactor 'smart_ops' into generic 'dimm_ops'
>       ndctl, debug: improve do_cmd output for ND_CMD_CALL
>       ndctl, list: teach the list command about the 'fsdax' and 'devdax' modes
>       ndctl, smart: move smart temperature parsing to a library routine
>       ndctl, test: trigger notifications
>       ndctl, test: listen for smart notifications

Note, I accidentally included a hugetlb-unit-test patch when sending
this out, which is why cover letter says 00/16 but there are 17
patches in this posting.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
