Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BD644202110C1
 for <linux-nvdimm@lists.01.org>; Thu, 29 Aug 2019 21:42:44 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id p23so5762833oto.0
 for <linux-nvdimm@lists.01.org>; Thu, 29 Aug 2019 21:40:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190807040029.11344-1-aneesh.kumar@linux.ibm.com>
 <156711523501.12658.8795324273505326478.git-patchwork-notify@kernel.org>
 <87lfvbnujk.fsf@linux.ibm.com>
In-Reply-To: <87lfvbnujk.fsf@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 29 Aug 2019 21:40:41 -0700
Message-ID: <CAPcyv4g7nQ201DV6r1-2Jq2vyHWzstHD2txwZvR5z6NMY_mqiw@mail.gmail.com>
Subject: Re: [PATCH] nvdimm/of_pmem: Provide a unique name for bus provider
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
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 29, 2019 at 9:31 PM Aneesh Kumar K.V
<aneesh.kumar@linux.ibm.com> wrote:
>
> patchwork-bot+linux-nvdimm@kernel.org writes:
>
> > Hello:
> >
> > This patch was applied to nvdimm/nvdimm.git (refs/heads/libnvdimm-for-next).
> >
> > On Wed,  7 Aug 2019 09:30:29 +0530 you wrote:
> >> ndctl utility requires the ndbus to have unique names. If not while
> >> enumerating the bus in userspace it drops bus with similar names.
> >> This results in us not listing devices beneath the bus.
> >>
> >> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> >> ---
> >>  drivers/nvdimm/of_pmem.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >
> > Here is a summary with links:
> >   - nvdimm/of_pmem: Provide a unique name for bus provider
> >     https://git.kernel.org/nvdimm/nvdimm/c/49bddc73d15c25a68e4294d76fc74519fda984cd
> >
> > You are awesome, thank you!
>
> We decided to fix this in ndctl tool? If we go with ndctl fix, we
> can drop the kernel change.

Oh, I was planning to do both any concerns if I keep the kernel
change, otherwise I'll need to rebase the branch.

> Parallely I am planning to do a  fix
> for papr_scm driver that will update the provider name as "papr_scm". That
> way we can find out the backend driver using
>
> :~> ndctl list -B
> [
>   {
>     "provider":"papr_scm",
>     "dev":"ndbus1"
>   },
>   {
>     "provider":"of_pmem",
>     "dev":"ndbus0"
>   }
> ]
>
>
> -aneesh
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
