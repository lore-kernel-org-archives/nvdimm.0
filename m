Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 675451A1E0E
 for <linux-nvdimm@lists.01.org>; Mon, 19 Sep 2016 14:48:38 -0700 (PDT)
Received: by mail-oi0-x233.google.com with SMTP id w11so214773453oia.2
 for <linux-nvdimm@lists.01.org>; Mon, 19 Sep 2016 14:48:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160916201013.555-1-brian.boylston@hpe.com>
References: <20160916201013.555-1-brian.boylston@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 19 Sep 2016 14:48:37 -0700
Message-ID: <CAPcyv4h0CdJXyaiNKbysns2JpXhjZQCxbnC7+n1VgDPD4HVidQ@mail.gmail.com>
Subject: Re: [ndctl PATCH v3 0/4] ndctl: add support for HPE type N SMART
 health data
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
To: Brian Boylston <brian.boylston@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Sep 16, 2016 at 1:10 PM, Brian Boylston <brian.boylston@hpe.com> wrote:
> This set of patches adds support for the HPE SMART DSM functions and enables
> ndctl to report DIMM health data for HPE type N NVDIMMs.  The relevant
> firmware interfaces are described in [1].
>
> The first patch virtualizes the ndctl_cmd_smart*() family of libndctl
> interfaces into a set of ndctl_smart_ops, allowing runtime implementation
> differentiation depending on the firmware support provided by a DIMM.
>
> The second and third patches add miscellaneous pieces needed for the
> final patch:
>
> The fourth patch adds a set of ndctl_smart_ops for the HPE1 DSM family,
> based on the firmware interfaces defined in [1].  These ndctl_smart_ops
> translate the HPE1 DSM output to match the interface of the existing
> Intel DSM-inspired smart_ops.  This delivers health reporting parity for
> HPE type N NVDIMMs, however:
>
> When evaluating this ndctl_smart_ops approach, please consider our goal of
> adding JSON exports for some of the additional health data defined in [1].
> I expect this would entail adding additional accessor functions to
> ndctl_smart_ops, but it's not clear whether or how to extend the existing
> get_flags()/check flags/get_data() model used by util_dimm_health_to_json().
>
> If you'd like to test these changes, note the following:
>
> . Some of the DSM functions for HPE type N NVDIMMs, including the ones used
>   by this patch, require the acpi_ipmi kernel module to be loaded, and you
>   may need to manually modprobe it.
>
> . Without [2], you'll need to include '--idle' in your ndctl invocation as
>   ndctl will consider type Ns to be disabled and will otherwise omit them.
>
> . Without [3], "alarm_temperature" and "alarm_spares" will be inaccurate.
>
> [1] https://github.com/HewlettPackard/hpe-nvm/raw/master/Documentation/NFIT_DSM_DDR4_NVDIMM-N_v84s.pdf
> [2] https://lists.01.org/pipermail/linux-nvdimm/2016-August/006619.html
> [3] https://lists.01.org/pipermail/linux-nvdimm/2016-September/006810.html
>
> Changes in v3:
>   - Dropped the smart_dimm_op() macro and open coded
>     ndctl_dimm_cmd_new_smart() and ndctl_dimm_cmd_new_smart_threshold().
>     (suggested by Dan)
>   - Do not fail add_dimm() if the read of nfit/commands fails, just set
>     dimm->dsm_family to -1 instead (suggested by Dan).  As part of this,
>     I also moved the read to after the has_nfit() check.
>   - Added missing bibliography to the commit message for the last patch.
>   - I realized that v2 wouldn't compile if HAS_SMART was not 1, so I
>     changed intel_smart_ops and hpe1_smart_ops into pointers and set them
>     to NULL if HAS_SMART != 1.  They are const because that seems to
>     avoid compiler warnings about unused variables in cases where
>     libndctl-private.h is included by something other than libndctl.c.
>
> Changes in v2:
>   New approach: taught libndctl how to translate between the HPE1 DSM
>   family and the existing ndctl_cmd_smart*() libndctl interfaces
>   (as suggested by Dan).
>
> Brian Boylston (4):
>   libndctl: introduce ndctl_smart_ops
>   libndctl: record dsm family in add_dimm()
>   libndctl: enable ND_CMD_CALL
>   libndctl: add support for the HPE1 family of DSM SMART functions

Thanks, applied and pushed out to the 'pending' branch for ndctl-55.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
