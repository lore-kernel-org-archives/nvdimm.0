Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDADD2C80
	for <nvdimm@lists.linux.dev>; Tue,  2 Nov 2021 20:27:15 +0000 (UTC)
Received: by mail-pg1-f170.google.com with SMTP id a9so417246pgg.7
        for <nvdimm@lists.linux.dev>; Tue, 02 Nov 2021 13:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S9/uPBwkZRiUzJQDpxI+P8iwIXeKmdu3cwDz3M4HyWI=;
        b=RFkHIHceCj97jTxd0cqNKg66vDCbgEJVqXbiiU4T37h4v2kLrus8V13M+rpYr2UYAL
         hrChVy9LVRNsI7qrJT6JLoaIGoBY4BuaYzTLv125f3WPUxzdr7t3/ukdObXjX/xNpkZb
         B9N8ZqRxOxSLWy6dUCtRQ3wVaPlPGIaZcdlHE352XPr6MZhvn/zmAgVSXuyhouTE8/r5
         mx057EHqJVD9dRlme8iTvPDJKnJRKgZpdUgb/e+/uai2TDvSJyEWnk95KB/b334APgHY
         lFhm20Co41g1jDK7VStYBZOnsnh9kxGq3Raio2M82IXtwsiyolzBxsUEkORB5Br/ZKwB
         67uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S9/uPBwkZRiUzJQDpxI+P8iwIXeKmdu3cwDz3M4HyWI=;
        b=IOMb8yOlbXYzKG+FipqiVoumsJNLRnP07V57ken5Uw77Xc4NTcQ9P5NQKOL34BKI1d
         oY3Tnrx15tjiRsUJAIK4ne1FjRJCdDsxA3Z/HF8YaIdPCwfhO81d+og5fHY2jGByxYqU
         64Db/LWFv/xwfOX5CCiVpYMc/0sfZ424R19m/4FkjtgC1gDlSuqqZTBdbnFFTpxKXL3C
         PH3gzqcO4CvUBPYarvSYTHH1D5k3cUj58YBTuweMy6NPiH0vg+1qJsPzvVKgKVoddy+R
         EoBa2r71UALngHHK8AsXGP8qhlCKHEU2SeLuJt3laW45LfWBTldiV8HYwa/6KV4JXs6U
         3pBg==
X-Gm-Message-State: AOAM530dfkK8+2nc3GAzK3ZZImZLj1hldNENFJZkOoBzDHSZyHRHMYj5
	8PhZaZMNSbDWHnyvbjkJqnpRQN2wTn+Rr77eC1E/Ug==
X-Google-Smtp-Source: ABdhPJzfDzeRQW5W7syHpC1+4xNowgh/ImhHZHqHXYDLheGIOrsQMqL7V/j01kUA0VL812n4VvfYmJG7C0ffncccBgw=
X-Received: by 2002:a63:85c6:: with SMTP id u189mr16312590pgd.377.1635884835379;
 Tue, 02 Nov 2021 13:27:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211007082139.3088615-1-vishal.l.verma@intel.com>
 <20211007082139.3088615-8-vishal.l.verma@intel.com> <CAPcyv4ifss448zuSRphx4d5RAtjZkgiBQirbLPMAJF04NPnZLg@mail.gmail.com>
 <fc7be48811b489b24f0287764d421e7482219638.camel@intel.com>
In-Reply-To: <fc7be48811b489b24f0287764d421e7482219638.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 2 Nov 2021 13:27:05 -0700
Message-ID: <CAPcyv4iJZ8hDp-jRuSjdRuO8px8_r_d-R9w4pqh5iTAc9w+uiw@mail.gmail.com>
Subject: Re: [ndctl PATCH v4 07/17] libcxl: add GET_HEALTH_INFO mailbox
 command and accessors
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "Widawsky, Ben" <ben.widawsky@intel.com>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 2, 2021 at 1:22 PM Verma, Vishal L <vishal.l.verma@intel.com> wrote:
>
> On Thu, 2021-10-14 at 09:01 -0700, Dan Williams wrote:
> > )
> >
> > On Thu, Oct 7, 2021 at 1:22 AM Vishal Verma <vishal.l.verma@intel.com> wrote:
> > >
> > > Add libcxl APIs to create a new GET_HEALTH_INFO mailbox command, the
> > > command output data structure (privately), and accessor APIs to return
> > > the different fields in the health info output.
> > >
> > > Cc: Ben Widawsky <ben.widawsky@intel.com>
> > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > > ---
> > >  cxl/lib/private.h  |  47 ++++++++
> > >  cxl/lib/libcxl.c   | 286 +++++++++++++++++++++++++++++++++++++++++++++
> > >  cxl/libcxl.h       |  38 ++++++
> > >  util/bitmap.h      |  23 ++++
> > >  cxl/lib/libcxl.sym |  31 +++++
> > >  5 files changed, 425 insertions(+)
> > >
> > > diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> > > index 3273f21..f76b518 100644
> > > --- a/cxl/lib/private.h
> > > +++ b/cxl/lib/private.h
> > > @@ -73,6 +73,53 @@ struct cxl_cmd_identify {
> > >         u8 qos_telemetry_caps;
> > >  } __attribute__((packed));
> > >
> > > +struct cxl_cmd_get_health_info {
> > > +       u8 health_status;
> > > +       u8 media_status;
> > > +       u8 ext_status;
> > > +       u8 life_used;
> > > +       le16 temperature;
> > > +       le32 dirty_shutdowns;
> > > +       le32 volatile_errors;
> > > +       le32 pmem_errors;
> > > +} __attribute__((packed));
> > > +
> > > +/* CXL 2.0 8.2.9.5.3 Byte 0 Health Status */
> > > +#define CXL_CMD_HEALTH_INFO_STATUS_MAINTENANCE_NEEDED_MASK             BIT(0)
> > > +#define CXL_CMD_HEALTH_INFO_STATUS_PERFORMANCE_DEGRADED_MASK           BIT(1)
> > > +#define CXL_CMD_HEALTH_INFO_STATUS_HW_REPLACEMENT_NEEDED_MASK          BIT(2)
> > > +
> > > +/* CXL 2.0 8.2.9.5.3 Byte 1 Media Status */
> > > +#define CXL_CMD_HEALTH_INFO_MEDIA_STATUS_NORMAL                                0x0
> > > +#define CXL_CMD_HEALTH_INFO_MEDIA_STATUS_NOT_READY                     0x1
> > > +#define CXL_CMD_HEALTH_INFO_MEDIA_STATUS_PERSISTENCE_LOST              0x2
> > > +#define CXL_CMD_HEALTH_INFO_MEDIA_STATUS_DATA_LOST                     0x3
> > > +#define CXL_CMD_HEALTH_INFO_MEDIA_STATUS_POWERLOSS_PERSISTENCE_LOSS    0x4
> > > +#define CXL_CMD_HEALTH_INFO_MEDIA_STATUS_SHUTDOWN_PERSISTENCE_LOSS     0x5
> > > +#define CXL_CMD_HEALTH_INFO_MEDIA_STATUS_PERSISTENCE_LOSS_IMMINENT     0x6
> > > +#define CXL_CMD_HEALTH_INFO_MEDIA_STATUS_POWERLOSS_DATA_LOSS           0x7
> > > +#define CXL_CMD_HEALTH_INFO_MEDIA_STATUS_SHUTDOWN_DATA_LOSS            0x8
> > > +#define CXL_CMD_HEALTH_INFO_MEDIA_STATUS_DATA_LOSS_IMMINENT            0x9
> > > +
> > > +/* CXL 2.0 8.2.9.5.3 Byte 2 Additional Status */
> > > +#define CXL_CMD_HEALTH_INFO_EXT_LIFE_USED_MASK                         GENMASK(1, 0)
> > > +#define CXL_CMD_HEALTH_INFO_EXT_LIFE_USED_NORMAL                       0x0
> > > +#define CXL_CMD_HEALTH_INFO_EXT_LIFE_USED_WARNING                      0x1
> > > +#define CXL_CMD_HEALTH_INFO_EXT_LIFE_USED_CRITICAL                     0x2
> > > +#define CXL_CMD_HEALTH_INFO_EXT_TEMPERATURE_MASK                       GENMASK(3, 2)
> > > +#define CXL_CMD_HEALTH_INFO_EXT_TEMPERATURE_NORMAL                     (0x0 << 2)
> > > +#define CXL_CMD_HEALTH_INFO_EXT_TEMPERATURE_WARNING                    (0x1 << 2)
> > > +#define CXL_CMD_HEALTH_INFO_EXT_TEMPERATURE_CRITICAL                   (0x2 << 2)
> >
> > So the kernel style for this would be to have:
> >
> > #define CXL_CMD_HEALTH_INFO_EXT_TEMPERATURE_NORMAL                    (0)
> > #define CXL_CMD_HEALTH_INFO_EXT_TEMPERATURE_WARNING                  (1)
> > #define CXL_CMD_HEALTH_INFO_EXT_TEMPERATURE_CRITICAL                   (2)
> >
> > ...and then to check the value it would be:
> >
> > FIELD_GET(CXL_CMD_HEALTH_INFO_EXT_TEMPERATURE_MASK, c->ext_status) ==
> > CXL_CMD_HEALTH_INFO_EXT_TEMPERATURE_NORMAL
> >
> > ...that way if we ever wanted to copy libcxl bits into the kernel it
> > will already be in the matching style to other CXL bitwise
> > definitions.
> >
> > I think FIELD_GET() would also clarify a few of your helpers below,
> > but yeah a bit more infrastructure to import.
>
> Looking at porting over FIELD_GET.. It wants to do
> '__BF_FIELD_CHECK()', which pulls in a lot of the compiletime_assert
> stuff to be able to BUILD_BUG_ON with a message.
>
> Any suggestions on how much we want to bring in?  I could drop the
> __BF_FIELD_CHECK checks, and then it's very straightforward. Or bring
> in the checks, but with a plain BUILD_BUG_ON instead of
> BUILD_BUG_ON_MSG..

I think plain BUILD_BUG_ON is an ok place to draw the line.
