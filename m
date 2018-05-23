Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x244.google.com (mail-ot0-x244.google.com
 [IPv6:2607:f8b0:4003:c0f::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 50166207E4E0B
 for <linux-nvdimm@lists.01.org>; Wed, 23 May 2018 10:50:15 -0700 (PDT)
Received: by mail-ot0-x244.google.com with SMTP id y10-v6so26209547otg.10
 for <linux-nvdimm@lists.01.org>; Wed, 23 May 2018 10:50:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1527097534.9654.6.camel@intel.com>
References: <152700595813.1878.7740364417021385747.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1527097534.9654.6.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 23 May 2018 10:50:14 -0700
Message-ID: <CAPcyv4hUveNR3R_QVbs47ORNXBEKMYKd-9yjjaP_oF9QLjemRA@mail.gmail.com>
Subject: Re: [ndctl PATCH] test: add a MADV_HWPOISON test
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 23, 2018 at 10:45 AM, Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
> On Tue, 2018-05-22 at 09:19 -0700, Dan Williams wrote:
>> Check that injecting soft-poison to a dax mapping results in SIGBUS with
>> the expected BUS_MCEERR_AR siginfo data.
>>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  test/dax-pmd.c |  130
>> ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 126 insertions(+), 4 deletions(-)
>
> Looks good, applied.
>

I do need to make a follow on patch to detect when MADV_HWPOISON will
work, because this will crash current kernels.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
