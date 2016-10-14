Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22d.google.com (mail-oi0-x22d.google.com
 [IPv6:2607:f8b0:4003:c06::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A33841A1DF5
 for <linux-nvdimm@lists.01.org>; Thu, 13 Oct 2016 17:19:09 -0700 (PDT)
Received: by mail-oi0-x22d.google.com with SMTP id t73so119079502oie.1
 for <linux-nvdimm@lists.01.org>; Thu, 13 Oct 2016 17:19:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <147630484183.28641.3160414367749359017.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147630484183.28641.3160414367749359017.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 13 Oct 2016 17:19:08 -0700
Message-ID: <CAPcyv4gAGroaoZBhKtSxptj+D7WYSiEnaP5-vEaH=nAMfwcb1Q@mail.gmail.com>
Subject: Re: [ndctl PATCH] libndctl: fix 'type-pun' warnings with hpe1 commands
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
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Oct 12, 2016 at 1:40 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> Fix warnings of the form:
>
>     libndctl-hpe1.c: In function 'hpe1_smart_valid':
>     libndctl-hpe1.c:78:15: warning: dereferencing type-punned pointer will
>         break strict-aliasing rules [-Wstrict-aliasing]
>         CMD_HPE1(cmd)->gen.nd_family != NVDIMM_FAMILY_HPE1 ||
>         ^
>     libndctl-hpe1.c:79:15: warning: dereferencing type-punned pointer will
>         break strict-aliasing rules [-Wstrict-aliasing]
>         CMD_HPE1(cmd)->gen.nd_command != NDN_HPE1_CMD_SMART ||
>         ^
>     libndctl-hpe1.c: In function 'hpe1_cmd_smart_get_flags':
>     libndctl-hpe1.c:93:55: warning: dereferencing type-punned pointer will
>         break strict-aliasing rules [-Wstrict-aliasing]
>     libndctl-hpe1.c:93:55: warning: dereferencing type-punned pointer will
>         break strict-aliasing rules [-Wstrict-aliasing]
>     libndctl-hpe1.c: In function 'hpe1_cmd_smart_get_health':
>     libndctl-hpe1.c:121:56: warning: dereferencing type-punned pointer will
>         break strict-aliasing rules [-Wstrict-aliasing]
>     libndctl-hpe1.c:121:56: warning: dereferencing type-punned pointer will
>         break strict-aliasing rules [-Wstrict-aliasing]
>
> ...for distributions that include "-Wstrict-aliasing" in CFLAGS.
>
> Cc: Brian Boylston <brian.boylston@hpe.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Brian, it occurs to me that I do not have unit test coverage for hpe1
command functionality.  Can you confirm that this patch does not break
anything?

For extra credit, I wouldn't say no if you instrumented the kernel's
nfit_test infrastructure to provide sample hpe1 data payload results.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
