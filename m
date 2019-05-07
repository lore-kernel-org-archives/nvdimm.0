Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8412921237AB8
 for <linux-nvdimm@lists.01.org>; Tue,  7 May 2019 08:09:56 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id o39so15225423ota.6
 for <linux-nvdimm@lists.01.org>; Tue, 07 May 2019 08:09:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190401051421.17878-1-aneesh.kumar@linux.ibm.com>
 <87pnoumql8.fsf@linux.ibm.com>
In-Reply-To: <87pnoumql8.fsf@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 7 May 2019 08:09:45 -0700
Message-ID: <CAPcyv4go1Ya=D-8O2JjecRA4GRDH1PdhntzjaxhYUQa+-srLiQ@mail.gmail.com>
Subject: Re: [PATCH v2] drivers/dax: Allow to include DEV_DAX_PMEM as builtin
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
Cc: Linux MM <linux-mm@kvack.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 7, 2019 at 4:50 AM Aneesh Kumar K.V
<aneesh.kumar@linux.ibm.com> wrote:
>
>
> Hi Dan,
>
> "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> writes:
>
> > This move the dependency to DEV_DAX_PMEM_COMPAT such that only
> > if DEV_DAX_PMEM is built as module we can allow the compat support.
> >
> > This allows to test the new code easily in a emulation setup where we
> > often build things without module support.
> >
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
>
> Any update on this. Can we merge this?

Applied for the v5.2 pull request.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
