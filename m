Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0F62CA3
	for <nvdimm@lists.linux.dev>; Wed, 26 Jan 2022 16:07:28 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id c3so22871833pls.5
        for <nvdimm@lists.linux.dev>; Wed, 26 Jan 2022 08:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gcv5s7rBRNBJ5HHAx5BTh92SWh3a8LAuqVI+SvJy7ts=;
        b=1COukkru4jBOb3S5Q67y/wjv81NVjc9WM7QbPEWSqbar+e9+5fYgWM77aP8uTtbr3Z
         rkaSmJed5oJ3Uxw4vUQ2OuzqOFf5FevD6sc4kE32NVwKbcWRgFhQxXFPCmK3gwmN0WFN
         ua4MXAaIOmZeS3Dk1iz3iLCz651wCJFjRL9RIF9VXmDAcno+lNQVeJlizh9bdgPON+qo
         GBbBVUiuU45LurCOTJ5/xeHh0Z9w1sIKWUIq0kOIH0KYzPGhL2/9YbS+WhsGx4ReK8vR
         ZMUEwnht2P0MunhPIix0dKSTgNbkXwb6eUDmCYvs2p2STwuS71fWw4fzKQqgNZCWkY/F
         aEug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gcv5s7rBRNBJ5HHAx5BTh92SWh3a8LAuqVI+SvJy7ts=;
        b=G6wO45a7XqvdNfZELPfsu0e5SpT/ZB90Je8M1iTnQR4+SibtuFSG7e02qawPXmGrtf
         j0PjEbUVpZMftMGhHhKZC4seCIeooJ32AupfdKgg9aVdS3Fy6KlTEEYHp1UlpDSkh45p
         Wpjm6paZIMFkL5NeCT+O5l9dLxozvMlRJaXsaPon6YC+0H4ZMEjCxbMf07JhCiJjdLqW
         8kEGAxXfjwcsAL7gqOo+2vXNtlkCbT81eWBWfGj6sgA+kNh30Jen7LGQCs/v4Uoh+8Bq
         pS4+KdKfZ0rutR6/KzhGPBO9P/F9cSPKtScMO4gvAnNpfzivnCSmkYPqtveKfyYEJFSQ
         sS4A==
X-Gm-Message-State: AOAM530r1NHt2RCDlF9gMMiZEQd/LSb/hdmwWb63s8XPmzAVt6uchoMY
	xZcudHP2J8E7b7RR5IVExGC/IP19DAdPNk372K78fQ==
X-Google-Smtp-Source: ABdhPJy1McJNZUNI3CIFgkyOW7NHw2oG5bzzyaZnDTSML8CbU3gzm1uIJISlctdV3bHiMOyqV8uYp+yriwc2u97Khhs=
X-Received: by 2002:a17:902:ce8d:b0:14b:4bc6:e81 with SMTP id
 f13-20020a170902ce8d00b0014b4bc60e81mr14603301plg.132.1643213248391; Wed, 26
 Jan 2022 08:07:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1642535478.git.alison.schofield@intel.com> <2072a34022dabcc92e3cc73b16c8008656e1084e.1642535478.git.alison.schofield@intel.com>
In-Reply-To: <2072a34022dabcc92e3cc73b16c8008656e1084e.1642535478.git.alison.schofield@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 26 Jan 2022 08:07:17 -0800
Message-ID: <CAPcyv4jde6kd1oT2ZEoGWDiB1E6QX2pYzSHWr=38jtY6XB5ATA@mail.gmail.com>
Subject: Re: [ndctl PATCH v3 1/6] libcxl: add GET_PARTITION_INFO mailbox
 command and accessors
To: "Schofield, Alison" <alison.schofield@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Jan 18, 2022 at 12:20 PM <alison.schofield@intel.com> wrote:
>
> From: Alison Schofield <alison.schofield@intel.com>
>
> Users need access to the CXL GET_PARTITION_INFO mailbox command
> to inspect and confirm changes to the partition layout of a memory
> device.
>
> Add libcxl APIs to create a new GET_PARTITION_INFO mailbox command,
> the command output data structure (privately), and accessor APIs to
> return the different fields in the partition info output.
>
> Per the CXL 2.0 specification, devices report partition capacities
> as multiples of 256MB. Define and use a capacity multiplier to
> convert the raw data into bytes for user consumption. Use byte
> format as the norm for all capacity values produced or consumed
> using CXL Mailbox commands.
>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Looks good to me, you might want to also add a short note about the
"cxl_cmd_new_get_partition_info()" API in the "=== MEMDEV: Commands"
section of Documentation/cxl/lib/libcxl.txt that I started here:

https://lore.kernel.org/r/164298557771.3021641.14904324834528700206.stgit@dwillia2-desk3.amr.corp.intel.com

Note that I'm not adding every single API there, but I think each
cxl_cmd_new_<command_type>() API could use a short note.

That can be a follow on depending on whether Vishal merges this first
or the topology enumeration series.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
