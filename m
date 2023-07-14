Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A261548D
	for <nvdimm@lists.linux.dev>; Fri, 14 Jul 2023 17:03:29 +0000 (UTC)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-98e1fc9d130so59661866b.0
        for <nvdimm@lists.linux.dev>; Fri, 14 Jul 2023 10:03:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689354208; x=1691946208;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+w920JXIkybPetWi046ZRPSw5JR8m5DRlgdvfm2InwE=;
        b=AwDAT+8C/4PNya7kINm2LUSvYWDRVO41YC38hD3niOsO/RLGnHPly+CEGMUzzEXoUY
         Cat4PhUK2c2CgC2vwxKM58+7LWrB+KuusXlgaEPTbHz6vO40V3oLygaoMZwIoxnXk3Hv
         Z9CCkWDclQd0Yi2A4Np1CWW29YWrTVAvelwJUEOf1n+79Ssb5wXSn8EVRFrEcKPbQYQz
         4pvR4Su3ak56L5GUY6Q9KEQjSXHLjqnXIsiYtAUv52HSAHv6hBLGUFSRqKeKhHWliwGl
         Y+u4iMEbrdrsk7lZJ2WVAFWcAB9CyDPl0ts9e7ktc+r6gh1VNT0JPKefi2bG9XijWfkB
         Uc2Q==
X-Gm-Message-State: ABy/qLYzKIQHi7XrLHmrf7qZK3TilMigpfoUP4d1QE6+Smxwrz7k+fvm
	FmGLDmS9UGmvzlrQJwxGEDjvfzb7TrKWQw/lArs=
X-Google-Smtp-Source: APBJJlFWCHKgeuKLMNl7eaHbz8gcf8jN858tJqH96sfgN3uW24NsbLp55ZfNoLGMu2IWNlOHM84r5nnzzB7FaGfF4vI=
X-Received: by 2002:a17:906:de:b0:993:d5e7:80f8 with SMTP id
 30-20020a17090600de00b00993d5e780f8mr4216969eji.7.1689354207604; Fri, 14 Jul
 2023 10:03:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230703080252.2899090-1-michal.wilczynski@intel.com>
In-Reply-To: <20230703080252.2899090-1-michal.wilczynski@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Fri, 14 Jul 2023 19:03:16 +0200
Message-ID: <CAJZ5v0gGoMOwWbEzMTkX3ShQU2_iq8fn6OwQ2GJu+YJ2Q=u9uw@mail.gmail.com>
Subject: Re: [PATCH v7 0/9] Remove .notify callback in acpi_device_ops
To: Michal Wilczynski <michal.wilczynski@intel.com>
Cc: linux-acpi@vger.kernel.org, rafael@kernel.org, dan.j.williams@intel.com, 
	vishal.l.verma@intel.com, lenb@kernel.org, dave.jiang@intel.com, 
	ira.weiny@intel.com, rui.zhang@intel.com, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 3, 2023 at 10:03=E2=80=AFAM Michal Wilczynski
<michal.wilczynski@intel.com> wrote:
>
> *** IMPORTANT ***
> This is part 1 - only drivers in acpi directory to ease up review
> process. Rest of the drivers will be handled in separate patchsets.
>
> Currently drivers support ACPI event handlers by defining .notify
> callback in acpi_device_ops. This solution is suboptimal as event
> handler installer installs intermediary function acpi_notify_device as a
> handler in every driver. Also this approach requires extra variable
> 'flags' for specifying event types that the driver want to subscribe to.
> Additionally this is a pre-work required to align acpi_driver with
> platform_driver and eventually replace acpi_driver with platform_driver.
>
> Remove .notify callback from the acpi_device_ops. Replace it with each
> driver installing and removing it's event handlers.
>
> This is part 1 - only drivers in acpi directory to ease up review
> process.
>
> v7:
>  - fix warning by declaring acpi_nfit_remove_notify_handler() as static
>
> v6:
>  - fixed unnecessary RCT in all drivers, as it's not a purpose of
>    this patch series
>  - changed error label names to simplify them
>  - dropped commit that remove a comma
>  - squashed commit moving code for nfit
>  - improved nfit driver to use devm instead of .remove()
>  - re-based as Rafael changes [1] are merged already
>
> v5:
>  - rebased on top of Rafael changes [1], they're not merged yet
>  - fixed rollback in multiple drivers so they don't leak resources on
>    failure
>  - made this part 1, meaning only drivers in acpi directory, rest of
>    the drivers will be handled in separate patchsets to ease up review
>
> v4:
>  - added one commit for previously missed driver sony-laptop,
>    refactored return statements, added NULL check for event installer
> v3:
>  - lkp still reported some failures for eeepc, fujitsu and
>    toshiba_bluetooth, fix those
> v2:
>  - fix compilation errors for drivers
>
> [1]: https://lore.kernel.org/linux-acpi/1847933.atdPhlSkOF@kreacher/
>
> Michal Wilczynski (9):
>   acpi/bus: Introduce wrappers for ACPICA event handler install/remove
>   acpi/bus: Set driver_data to NULL every time .add() fails
>   acpi/ac: Move handler installing logic to driver
>   acpi/video: Move handler installing logic to driver
>   acpi/battery: Move handler installing logic to driver
>   acpi/hed: Move handler installing logic to driver
>   acpi/nfit: Move handler installing logic to driver
>   acpi/nfit: Remove unnecessary .remove callback
>   acpi/thermal: Move handler installing logic to driver

Dan hasn't spoken up yet, but I went ahead and queued up the patches
(with some modifications) for 6.6.

I've edited the subjects and rewritten the changelogs and I've
adjusted some white space around function calls (nothing major).

Thanks!
