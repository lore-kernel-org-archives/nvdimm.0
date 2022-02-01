Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E25E2CA5
	for <nvdimm@lists.linux.dev>; Tue,  1 Feb 2022 01:32:08 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id h12so15630055pjq.3
        for <nvdimm@lists.linux.dev>; Mon, 31 Jan 2022 17:32:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XRLAa5TR3EHkLrr6oIGYc+Zb7vJHNpVte3URB1U9ueY=;
        b=zKyYFVyU81epyr6OHJTOSiyb6PsiTtrJTCVhwrmPXcj0knLWiDmoq1hNrfqvy3e+BX
         ZoivvcPqEfvtZj9Pvbd7GVotp5WoGIYiTe9o6t8UMWi1f/575/L2PBTyUmfrUm6L8syn
         iWn3uMJL+1EDykBBQbO/4Wp5dn81yc0AoGrR24XgmgZEMVb6fi6FTcUF06OGYxV3TvlV
         ZwsyWEP2vME8ViVZKyR9xQjzCkz8aURUBCtvQwA+XNqJJmvuwjgfKU53/SpDNzN1r49A
         kwtt78SSsmz18x/fueuQh56IhDaE6mdzOEcXnkqKRy28BzAzBOCaW/9YWOgR3MtxYsir
         hXJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XRLAa5TR3EHkLrr6oIGYc+Zb7vJHNpVte3URB1U9ueY=;
        b=JdQ/xeAnN+M5D4j6xTPnzmWgjzAjha+QDN+xRXHwaNR8OwM6vTK21dlO5jHLDOlTSM
         OxqrRnmxcAhAk1uPG0HFX3XrbHS2MWe8PY0Z9FwGM/e2Az7xp7O+szQZMLxjoncViAM4
         kaDwCQusR4kZN/ZJ2S86Q1VsmsPHirvYq6gksIOtc1/164d4j72zm45b4tyslrm3znBK
         xX5U1WjlsppTpFhQez3KR1zkdVJgXLsb7deFi8tMQWKe2737k/jxWTz5WY9S0K7Tr8S0
         dYHl33Sm/YLQQcL/3aGyZAacEHk77ziJWYEbmc59Ht6uMraiMJoaC6isMYPgG0zU5X25
         bpwA==
X-Gm-Message-State: AOAM532VBt6D98+iS3v9+kthOeRKuyRQLQU6be6oUNjCr7JmXhaDxYH+
	CCqOCzZRQf99Y1Hn5kqYca4T5x5QN+N5H6CDoiY/PxJCsClWNA==
X-Google-Smtp-Source: ABdhPJyH62To2f39TJHPMQD+PmPnu3hOx6CJ9lnIfxcmZ+5Y+itByJr22t1wkvb4MTSNqEGhcGZ4Ees/OP1/BE9bd5o=
X-Received: by 2002:a17:902:b20a:: with SMTP id t10mr23263040plr.132.1643679127836;
 Mon, 31 Jan 2022 17:32:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1642535478.git.alison.schofield@intel.com>
 <e98fa18538c42c40b120d5c22da655d199d0329d.1642535478.git.alison.schofield@intel.com>
 <CAPcyv4j4Nq1AAxH2CybQCH3pcBpCWgCsnY5i=OfKQXd_C_3xWA@mail.gmail.com> <20220201012509.GA913535@alison-desk>
In-Reply-To: <20220201012509.GA913535@alison-desk>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 31 Jan 2022 17:32:00 -0800
Message-ID: <CAPcyv4imtsKLm8BqYOh53hGh46T0BLeUROb8BJWbGzGyPpzJJQ@mail.gmail.com>
Subject: Re: [ndctl PATCH v3 5/6] libcxl: add interfaces for
 SET_PARTITION_INFO mailbox command
To: Alison Schofield <alison.schofield@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Jan 31, 2022 at 5:20 PM Alison Schofield
<alison.schofield@intel.com> wrote:
>
> Dan, One follow up below...
>
> On Wed, Jan 26, 2022 at 03:41:14PM -0800, Dan Williams wrote:
> > On Tue, Jan 18, 2022 at 12:20 PM <alison.schofield@intel.com> wrote:
> > >
> > > From: Alison Schofield <alison.schofield@intel.com>
> > >
> > > Users may want the ability to change the partition layout of a CXL
> > > memory device.
> > >
> > > Add interfaces to libcxl to allocate and send a SET_PARTITION_INFO
> > > mailbox as defined in the CXL 2.0 specification.
> > >
> > > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > > ---
> > >  cxl/lib/libcxl.c   | 50 ++++++++++++++++++++++++++++++++++++++++++++++
> > >  cxl/lib/libcxl.sym |  5 +++++
> > >  cxl/lib/private.h  |  8 ++++++++
> > >  cxl/libcxl.h       |  5 +++++
> > >  4 files changed, 68 insertions(+)
> > >
> > > diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> > > index 5b1fc32..5a5b189 100644
> > > --- a/cxl/lib/libcxl.c
> > > +++ b/cxl/lib/libcxl.c
> > > @@ -1230,6 +1230,21 @@ cxl_cmd_partition_info_get_next_persistent_bytes(struct cxl_cmd *cmd)
> > >         cmd_partition_get_capacity_field(cmd, next_persistent_cap);
> > >  }
> > >
> > > +CXL_EXPORT struct cxl_cmd *cxl_cmd_new_set_partition_info(struct cxl_memdev *memdev,
> > > +               unsigned long long volatile_capacity, int flags)
> > > +{
> > > +       struct cxl_cmd_set_partition_info *set_partition;
> > > +       struct cxl_cmd *cmd;
> > > +
> > > +       cmd = cxl_cmd_new_generic(memdev,
> > > +                       CXL_MEM_COMMAND_ID_SET_PARTITION_INFO);
> > > +
> > > +       set_partition = (struct cxl_cmd_set_partition_info *)cmd->send_cmd->in.payload;
> >
> > ->in.payload is a 'void *', no casting required.
> >
>
> send_cmd->in.payload is a __u64 so this cast is needed.
>
> Of course, I wondered what Dan was thinking ;) and I see that struct
> cxl_cmd's input_payload is indeed a 'void *'.
>
> I believe this is the correct payload here, umm..  because it works ;)
>
> But - let me know if you suspect something is off here.

You're right...

...however :), I think this casting is what the core
cxl_cmd_alloc_send() helper is doing for everyone when it does:

cmd->send_cmd->in.payload = (u64)cmd->input_payload;

...so cxl_cmd_new_set_partition_info() can safely switch to the
shorter cmd->input_payload and drop its own redundant local casting.
