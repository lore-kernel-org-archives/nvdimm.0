Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1FB7F2114842B
 for <linux-nvdimm@lists.01.org>; Tue, 25 Sep 2018 13:18:06 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id q4-v6so12654464otf.13
 for <linux-nvdimm@lists.01.org>; Tue, 25 Sep 2018 13:18:06 -0700 (PDT)
MIME-Version: 1.0
References: <153622549721.14298.8116794954073122489.stgit@warthog.procyon.org.uk>
 <153622557095.14298.10281337300003012767.stgit@warthog.procyon.org.uk>
In-Reply-To: <153622557095.14298.10281337300003012767.stgit@warthog.procyon.org.uk>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 25 Sep 2018 13:17:54 -0700
Message-ID: <CAPcyv4gmMwRAG=VxWNyeacxdsPCsaT+BtR+27+bHT=6heAZ3sQ@mail.gmail.com>
Subject: Re: [PATCH 10/11] UAPI: ndctl: Remove use of PAGE_SIZE [ver #2]
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
To: David Howells <dhowells@redhat.com>
Cc: Linux API <linux-api@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Sep 6, 2018 at 2:19 AM David Howells <dhowells@redhat.com> wrote:
>
> The macro PAGE_SIZE isn't valid outside of the kernel, so it should not
> appear in UAPI headers.
>
> Furthermore, the actual machine page size could theoretically change from
> an application's point of view if it's running in a container that gets
> migrated to another machine (say 4K/ppc64 to 64K/ppc64).
>
> Fixes: f2ba5a5baecf ("libnvdimm, namespace: make min namespace size 4K")
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Dan Williams <dan.j.williams@intel.com>

Acked-by: Dan Williams <dan.j.williams@intel.com>

Let me know if you want me to pick this up for 4.20.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
