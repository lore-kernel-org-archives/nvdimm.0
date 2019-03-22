Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6306E211E9593
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 16:45:38 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id 103so3412064otd.9
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 16:45:38 -0700 (PDT)
MIME-Version: 1.0
References: <155329790943.63917.7917763965011178186.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <155329790943.63917.7917763965011178186.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 22 Mar 2019 16:45:25 -0700
Message-ID: <CAPcyv4g3N8fwO2pFZ8KB_xPm7+zH8aaw7HgXj=VfztPz3oPmvw@mail.gmail.com>
Subject: Re: [PATCH v2] libnvdimm/security: Support a zero-key for secure-erase
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 22, 2019 at 4:40 PM Dave Jiang <dave.jiang@intel.com> wrote:
>
> Adding support to allow secure erase to happen when security state is not
> enabled. Key data of 0's will be passed in.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>
> v2:
> - Make patch header explicitly zero key (Dan)
> - Declare global static zero key (Dan)
> - Make nfit_test explicitly test zero key (Dan)

Looks good. I'm going to add a sentence to the changelog pointing out
that the kernel is already supporting a zero key for some of the other
security interfaces. That makes this effectively a fix to unify
semantics across commands, i.e. something I can reasonably justify as
a commit that needs to be backported to v5.0 and suitable for v5.1-rc.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
