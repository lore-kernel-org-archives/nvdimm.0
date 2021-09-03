Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE5B72
	for <nvdimm@lists.linux.dev>; Fri,  3 Sep 2021 17:00:52 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id j1so4022659pjv.3
        for <nvdimm@lists.linux.dev>; Fri, 03 Sep 2021 10:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bh/6FeY7+ZnPI+tefv/vYOgf48UThPj2tw460pbHy7w=;
        b=Zq7F/ljxsg/mfu440Fppwa70bVMfNT+SbtvhHExDwIh3Xf0cxOst43f2yLTZ3RptZD
         miHI64RI+3eVWk0Xu/3vRj4qAA/3kLxsuAbCvRZwNF2TADFlYMMCvmIQ41rwU1x5jtI3
         kmQTWrW+EWStmGxMw9HTB2lAYut9K13GLUFa3HqWVpKPvoeCWhyITg4GGuWREgPLkPM7
         8yUma7BslVb8GZl+ZOLkyVpK930Qu1yNSwJFhW6WeqR1gAD94Evx5zljUbTIJbrNzfmd
         y/G7pdWG0E9GutoUlEANsw+Kn6tH4oLmjg4Aon2iHNXnkIT6vOZeCiA97wsY44Y4xT25
         poFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bh/6FeY7+ZnPI+tefv/vYOgf48UThPj2tw460pbHy7w=;
        b=ijn/oNOIJx2MCclKHmOM/KEtKp5QTbKvAla2UzOA3bpFDoDtsctTUgsT0fRc7vCEE1
         W79QxMDWaxp+xp9uJh3HqAofVIErTsiizKaZwUTR12yamxvQhnNMehDsH1WaoaSXIcl7
         Uyb66Svi395Jwzwwt2v7J1Vk5RU6kOR0RClYY+NK4+bjmzKdm1PQkpPqwCtHA6UMCJ9a
         qrtsz/IiMNfKZf0Z+511+9hTOIkPZwpSIoVHeYq04mhGfRtJa/CqpErTpBhF3UYE6AMl
         AUBv9gAZj1dVkuVflvlZo2hV7JJDVUxC7xQKmTFW/8Tn3C9HlbVI7kafq5CWP4M/Wy95
         HJ7w==
X-Gm-Message-State: AOAM532I7xaRNj8A1I33Bvlxox2kAKD1JSjhG0o7OFd3XsgzcIBzOanS
	pukbGC+psT84GrzqaCoQc29b9un0NIktFNgF1UxEiQ==
X-Google-Smtp-Source: ABdhPJwWE/3n7iSRu/A2Mgr1YlmlEFRvq3U+YdWYPUOj9uJlg75Y1IAlp2jEU3E3b8X07WMkJOqR7TDYtbvjSiRrh9o=
X-Received: by 2002:a17:90b:513:: with SMTP id r19mr1678868pjz.93.1630688452151;
 Fri, 03 Sep 2021 10:00:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
 <162982120115.1124374.30709335221651520.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <162982120115.1124374.30709335221651520.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 3 Sep 2021 10:00:41 -0700
Message-ID: <CAPcyv4hKS2aNLFCRbRk=1vqwbhMgdpMnkyvx+S_nLduna1KpQA@mail.gmail.com>
Subject: Re: [PATCH v3 14/28] libnvdimm/labels: Introduce CXL labels
To: linux-cxl@vger.kernel.org
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>, Vishal L Verma <vishal.l.verma@intel.com>, 
	"Schofield, Alison" <alison.schofield@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	"Weiny, Ira" <ira.weiny@intel.com>, Ben Widawsky <ben.widawsky@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Aug 24, 2021 at 9:06 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> Now that all of use sites of label data have been converted to nsl_*
> helpers, introduce the CXL label format. The ->cxl flag in
> nvdimm_drvdata indicates the label format the device expects. A
> follow-on patch allows a bus provider to select the label style.
>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/nvdimm/label.c |   54 +++++++++++++------
>  drivers/nvdimm/label.h |  108 ++++++++++++++++++++++++++------------
>  drivers/nvdimm/nd.h    |  135 +++++++++++++++++++++++++++++++++++++-----------
>  3 files changed, 216 insertions(+), 81 deletions(-)
[..]
> diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
> index 76ecd0347dc2..0ef2e20fce57 100644
> --- a/drivers/nvdimm/label.h
> +++ b/drivers/nvdimm/label.h
> @@ -95,41 +95,78 @@ struct cxl_region_label {
>         __le64 checksum;
>  };
>
> -/**
> - * struct nd_namespace_label - namespace superblock
> - * @uuid: UUID per RFC 4122
> - * @name: optional name (NULL-terminated)
> - * @flags: see NSLABEL_FLAG_*
> - * @nlabel: num labels to describe this ns
> - * @position: labels position in set
> - * @isetcookie: interleave set cookie
> - * @lbasize: LBA size in bytes or 0 for pmem
> - * @dpa: DPA of NVM range on this DIMM
> - * @rawsize: size of namespace
> - * @slot: slot of this label in label area
> - * @unused: must be zero
> - */
>  struct nd_namespace_label {
> -       u8 uuid[NSLABEL_UUID_LEN];
> -       u8 name[NSLABEL_NAME_LEN];
> -       __le32 flags;
> -       __le16 nlabel;
> -       __le16 position;
> -       __le64 isetcookie;
> -       __le64 lbasize;
> -       __le64 dpa;
> -       __le64 rawsize;
> -       __le32 slot;
> -       /*
> -        * Accessing fields past this point should be gated by a
> -        * namespace_label_has() check.
> -        */
> -       u8 align;
> -       u8 reserved[3];
> -       guid_t type_guid;
> -       guid_t abstraction_guid;
> -       u8 reserved2[88];
> -       __le64 checksum;
> +       union {
> +               /**
> +                * struct nvdimm_cxl_label - CXL 2.0 Table 212
> +                * @type: uuid identifying this label format (namespace)
> +                * @uuid: uuid for the namespace this label describes
> +                * @name: friendly name for the namespace
> +                * @flags: NSLABEL_FLAG_UPDATING (all other flags reserved)
> +                * @nrange: discontiguous namespace support
> +                * @position: this label's position in the set
> +                * @dpa: start address in device-local capacity for this label
> +                * @rawsize: size of this label's contribution to namespace
> +                * @slot: slot id of this label in label area
> +                * @align: alignment in SZ_256M blocks
> +                * @region_uuid: host interleave set identifier
> +                * @abstraction_uuid: personality driver for this namespace
> +                * @lbasize: address geometry for disk-like personalities
> +                * @checksum: fletcher64 sum of this label
> +                */

It turns out that scripts/kernel-doc does not accept indented
kernel-doc within a union. So, I rewrote this hunk like this:

@@ -117,7 +117,7 @@ struct cxl_region_label {
  * @reserved2: reserved
  * @checksum: fletcher64 sum of this object
  */
-struct nd_namespace_label {
+struct nvdimm_efi_label {
        u8 uuid[NSLABEL_UUID_LEN];
        u8 name[NSLABEL_NAME_LEN];
        __le32 flags;
@@ -130,7 +130,7 @@ struct nd_namespace_label {
        __le32 slot;
        /*
         * Accessing fields past this point should be gated by a
-        * namespace_label_has() check.
+        * efi_namespace_label_has() check.
         */
        u8 align;
        u8 reserved[3];
@@ -140,11 +140,57 @@ struct nd_namespace_label {
        __le64 checksum;
 };

+/**
+ * struct nvdimm_cxl_label - CXL 2.0 Table 212
+ * @type: uuid identifying this label format (namespace)
+ * @uuid: uuid for the namespace this label describes
+ * @name: friendly name for the namespace
+ * @flags: NSLABEL_FLAG_UPDATING (all other flags reserved)
+ * @nrange: discontiguous namespace support
+ * @position: this label's position in the set
+ * @dpa: start address in device-local capacity for this label
+ * @rawsize: size of this label's contribution to namespace
+ * @slot: slot id of this label in label area
+ * @align: alignment in SZ_256M blocks
+ * @region_uuid: host interleave set identifier
+ * @abstraction_uuid: personality driver for this namespace
+ * @lbasize: address geometry for disk-like personalities
+ * @reserved: reserved
+ * @checksum: fletcher64 sum of this label
+ */
+struct nvdimm_cxl_label {
+       u8 type[NSLABEL_UUID_LEN];
+       u8 uuid[NSLABEL_UUID_LEN];
+       u8 name[NSLABEL_NAME_LEN];
+       __le32 flags;
+       __le16 nrange;
+       __le16 position;
+       __le64 dpa;
+       __le64 rawsize;
+       __le32 slot;
+       __le32 align;
+       u8 region_uuid[16];
+       u8 abstraction_uuid[16];
+       __le16 lbasize;
+       u8 reserved[0x56];
+       __le64 checksum;
+};
+
+struct nd_namespace_label {
+       union {
+               struct nvdimm_cxl_label cxl;
+               struct nvdimm_efi_label efi;
+       };
+};
+
