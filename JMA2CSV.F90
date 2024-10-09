!!! DATE: 2024.10
!!! 
!!! FILE: JMA2CSV.F90
!!! 
!!! AUTHOR: Zhu Dengda
!!! 
!!! 将JMA官网归档的地震目录转为csv格式，只对其中我需要的部分转换
!!! 这样方便我后续用python读取处理，
!!! 
!!! 由于数据结构的特殊性，这里采用FORTRAN代码进行处理，方便处理FORMAT


program main
    implicit none 
    integer :: iost
    integer :: year, month, day, hour, minu
    integer :: latd, lond, pos_space, int_depth
    real    :: secs, osig, latm, latmsig, lonm, lonmsig
    real    :: lat, lon, depth, depsig, mag1, mag2
    character :: rtyp, mtyp1, mtyp2, ttab, locprec, subinf, maxints
    character :: dmgcls, tsmcls, hypflg
    integer   :: district, region, nsta
    character(len=24)  :: regionname

    character(len=500) :: line
    character(len=500) :: input_file, output_file
    character(len=27)  :: jststr
    integer :: unit_in, unit_out

    call get_command_argument(1, input_file)
    call get_command_argument(2, output_file)

    ! 打开输入文件
    unit_in = 10
    open(unit=unit_in, file=input_file, status='old', action='read')

    ! 打开输出文件
    unit_out = 20
    open(unit=unit_out, file=output_file, status='replace', action='write')

    ! 输出csv列名
    write(unit_out, '("jst_orig,evla,evlo,evdp,mag")')

    ! 读取数据并写入CSV
    do while (.true.)
        ! 变量初始化
        year = -1
        month = -1
        day = -1
        hour = -1
        minu = -1
        secs = -1.0
        osig = -1.0
        latd = -999
        latm = -999.0
        latmsig = -999.0
        lond = -999
        lonm = -999.0
        lonmsig = -999.0
        depth = -999.0
        depsig = -999.0
        mag1 = -999.0
        mtyp1 = 'N'
        mag2 = -999.0
        mtyp2 = 'N'

        ttab = 'N'
        locprec = 'N'
        subinf = 'N'
        maxints = 'N'
        dmgcls = 'N'
        tsmcls = 'N'
        district = -1
        region = -999
        regionname = 'N'
        nsta = -999
        hypflg = 'N'

        ! 读取一条事件
        read(unit_in, '(A)', iostat=iost) line
        if (iost /= 0) exit  ! 结束循环

        ! 根据JMA官网给出的FORMTAT格式读取数据
        read(line(1:44), &
        '(A1,I4,I2,I2,I2,I2,F4.2,F4.2, &
          I3,F4.2,F4.2,I4,F4.2,F4.2)', iostat=iost) &
        rtyp, year, month, day, hour, minu, secs, osig, &
        latd, latm, latmsig, lond, lonm, lonmsig
        
        ! 尝试读取深度
        ! 找到字符串中的空格位置
        pos_space = index(line(45:49), ' ')
        if (pos_space == 4) then
            ! 如果空格在第4个字符，尝试读取为I3格式
            read(line(45:49), '(I3)', iostat=iost) int_depth
            depth = 1.0*int_depth
        else
            ! 否则读取为F5.2格式
            read(line(45:49), '(F5.2)', iostat=iost) depth
        end if

        ! 继续往后读取
        read(line(50:), &
        '(F3.2,F2.1,A1,F2.1,A1,&
          A1,A1,A1,A1,A1,A1,&
          I1,I3,A24,I3,A1)', iostat=iost) &
        depsig, mag1, mtyp1, mag2, mtyp2, &
        ttab, locprec, subinf, maxints, dmgcls, tsmcls, &
        district, region, regionname, nsta, hypflg


        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        ! 将度、分格式的经纬度转为浮点数
        lat = latd + latm/60.0
        lon = lond + lonm/60.0
        
        ! 将发阵时刻整理成一个标准字符串
        write(jststr, '(I4.4,"-",I2.2,"-",I2.2,"T",I2.2,":",I2.2,":",I2.2,F0.6,"Z")') &
        year, month, day, hour, minu, int(secs), secs-int(secs)


        ! 输出到csv文件中
        write(unit_out, '(A27,",",F10.5,",",F10.5,",",F8.2,",",F5.1)') &
        jststr, lat, lon, depth, mag1
    end do

    ! 关闭文件
    close(unit_in)
    close(unit_out)


end program