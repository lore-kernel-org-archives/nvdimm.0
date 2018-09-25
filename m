Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5391921143991
 for <linux-nvdimm@lists.01.org>; Tue, 25 Sep 2018 13:22:33 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id s69-v6so2623089oie.10
 for <linux-nvdimm@lists.01.org>; Tue, 25 Sep 2018 13:22:33 -0700 (PDT)
MIME-Version: 1.0
References: <153622549721.14298.8116794954073122489.stgit@warthog.procyon.org.uk>
 <153622556444.14298.5971956747198405225.stgit@warthog.procyon.org.uk>
In-Reply-To: <153622556444.14298.5971956747198405225.stgit@warthog.procyon.org.uk>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 25 Sep 2018 13:22:21 -0700
Message-ID: <CAPcyv4jjxh955mWEubnGiENVQVeCcZ9YWv8YPBKfWMw-gh1z2w@mail.gmail.com>
Subject: Re: [PATCH 09/11] UAPI: ndctl: Fix g++-unsupported initialisation in
 headers [ver #2]
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
> The following code in the linux/ndctl header file:
>
>         static inline const char *nvdimm_bus_cmd_name(unsigned cmd)
>         {
>                 static const char * const names[] = {
>                         [ND_CMD_ARS_CAP] = "ars_cap",
>                         [ND_CMD_ARS_START] = "ars_start",
>                         [ND_CMD_ARS_STATUS] = "ars_status",
>                         [ND_CMD_CLEAR_ERROR] = "clear_error",
>                         [ND_CMD_CALL] = "cmd_call",
>                 };
>
>                 if (cmd < ARRAY_SIZE(names) && names[cmd])
>                         return names[cmd];
>                 return "unknown";
>         }
>
> is broken in a number of ways:
>
>  (1) ARRAY_SIZE() is not generally defined.
>
>  (2) g++ does not support "non-trivial" array initialisers fully yet.
>
>  (3) Every file that calls this function will acquire a copy of names[].
>
> The same goes for nvdimm_cmd_name().
>
> Fix all three by converting to a switch statement where each case returns a
> string.  That way if cmd is a constant, the compiler can trivially reduce it
> and, if not, the compiler can use a shared lookup table if it thinks that is
> more efficient.
>
> A better way would be to remove these functions and their arrays from the
> header entirely.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Dan Williams <dan.j.williams@intel.com>

Acked-by: Dan Williams <dan.j.williams@intel.com>

...again let me know if you'll take this with g++ series or want me to
carry it directly.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
