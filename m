Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BB4A11A1E00
 for <linux-nvdimm@lists.01.org>; Mon, 27 Jun 2016 12:39:09 -0700 (PDT)
Received: by mail-oi0-x233.google.com with SMTP id r2so214833878oih.2
 for <linux-nvdimm@lists.01.org>; Mon, 27 Jun 2016 12:38:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160627192812.GD20767@omniknight.lm.intel.com>
References: <146698346627.40541.14661847967712551305.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146698348937.40541.3876891950806088867.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160627192812.GD20767@omniknight.lm.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 27 Jun 2016 12:38:34 -0700
Message-ID: <CAPcyv4gXbLNx4Q7Tff84eZynueL_TyJj4gravK0DrT6wUQcvjA@mail.gmail.com>
Subject: Re: [ndctl PATCH 4/9] ndctl, list: allow limiting namespace listing
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 27, 2016 at 12:28 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> On 06/26, Dan Williams wrote:
>> In addition to filtering by bus, dimm, and/or region, introduce
>> -n/--namespace to limit the listing to the given namespace.
>>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  Documentation/ndctl-list.txt |    6 ++++++
>>  ndctl/builtin-list.c         |    6 ++++++
>>  util/filter.c                |   21 +++++++++++++++++++++
>>  util/filter.h                |    2 ++
>>  4 files changed, 35 insertions(+)
>>
> This needs a bash completion update as follows (feel free to squash in
> or keep separatley..):
>
> From b6d09ff03b7ed16efdc4169aec0442d5c32053bd Mon Sep 17 00:00:00 2001
> From: Vishal Verma <vishal.l.verma@intel.com>
> Date: Mon, 27 Jun 2016 13:22:58 -0600
> Subject: [PATCH] ndctl: bash completion updates for the --namespace= filter
>
> Add completion for the new --namespace= filter.
> This will list idle namespaces for completion. It could possibly be made
> smarter by checking if a '--idle' or '-i' has been specified on the
> command line so far, but maybe that's a bit confusing for the user?
>
> For now, enable the simpler path of listing everything for completion.
>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Thanks! Applied as a standalone patch.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
